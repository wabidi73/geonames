        import { getRecord, getFieldValue } from "lightning/uiRecordApi";
        import { LightningElement, api, wire,track  } from "lwc";
        import { ShowToastEvent } from 'lightning/platformShowToastEvent';
        import getWheatherInfo from "@salesforce/apex/WeatherController.getWheatherInfo";
        import sendWetherReport from "@salesforce/apex/WeatherController.sendWetherReport";
        
        import ACCOUNT_LATITUDE_FIELD from "@salesforce/schema/Account.BillingLatitude";
        import ACCOUNT_LONGITUDE_FIELD from "@salesforce/schema/Account.BillingLongitude";
        
        import Id from '@salesforce/user/Id';
        import USER_LONGITUDE_FIELD from '@salesforce/schema/User.Longitude';
        import  USER_LATITUDE_FIELD from '@salesforce/schema/User.Latitude';
        import  USER_Email_FIELD from '@salesforce/schema/User.Email';
        import { CurrentPageReference } from 'lightning/navigation';

        const fields = [ACCOUNT_LATITUDE_FIELD, ACCOUNT_LONGITUDE_FIELD];
        export default class WeatherLWC extends LightningElement {

          @api recordId;
          isAccount=false;
          accountId;
          longitude;
          windSpeed;
          temperature;
          humidity;
          weatherCondition;
          latitudeFinal;
          longitudeFinal;
          isSfPage;
          htmlBody;
          //get latitude and longiture for the connected user
          @wire(getRecord, { recordId: Id, fields: [USER_LONGITUDE_FIELD, USER_LATITUDE_FIELD ,USER_Email_FIELD]}) 
          currentUserInfo({error, data}) {
              if (data) {
                  this.currentUserLongitude = data.fields.Longitude.value;
                  this.currentUserLatitude = data.fields.Latitude.value;
                  this.currentUserEmail =data.fields.Email.value
                 this.getWeatherInfo();
              } else if (error) {
                  this.error = error ;
              }
          }
       //get latitude and longiture for the account 
          @wire(getRecord, { recordId: "$recordId", fields })
          
          currentAccountInfo({error, data}) {
            if (data) {
                this.currentAccountLongitude = data.fields.BillingLongitude.value;
                this.currentAccountLatitude = data.fields.BillingLatitude.value;
                this.accountId=data.id;
                this.isAccount=true;
               this.getWeatherInfo();
            } else if (error) {
                this.error = error ;
            }
        }
          //Get current page ( to test if we are in salesforce page)
          @wire(CurrentPageReference)
          wiredCurrentPageReference(currentPageReference) {
              this.isSfPage = currentPageReference?.type.includes('standard__')?true:false;
          }
    
          get windSpeedValue() {
          
             return this.windSpeed;
           }
           get temperatureValue() {
           
             return this.temperature;
           }
          get humidityValue() {
           
             return this.humidity;
           }
           get weatherConditionValue() {
          
             return this.weatherCondition;
           }
          get latitudeValue() {
       
            return this.latitude;
          }
        
          get longitudeValue() {
          
            return this.longitude;
          }
     

          handleLatitudeChange(event){
            this.latitude = event.target.value;
            this.getWeatherInfo();
        } 
    
        handleLogitudeChange(event){
            this.longitude = event.target.value;
            this.getWeatherInfo();
        } 

        constructor() {
          super();
          this.latitudeFinal =undefined;
          this.longitudeFinal=undefined;
          
        }
       renderedCallback() {
         
          this.getWeatherInfo();
        }
        // method to call geonames web service and return weather info
         getWeatherInfo() {
         //if the source call is a salesforce page 
          if(this.isSfPage){
          
            this.latitudeFinal=this.isAccount ?this.currentAccountLatitude :this.currentUserLatitude;
            this.longitudeFinal=this.isAccount?this.currentAccountLongitude:this.currentUserLongitude;
           
          }
          //if the componenet is called froman external site
          else{
            
            this.latitudeFinal =this.latitude;
            this.longitudeFinal=this.longitude;
          }
             console.log('latitude: ' + this.latitudeFinal);
             console.log('longitude: ' + this.longitudeFinal);

          getWheatherInfo({ latitude: this.latitudeFinal,longitude: this.longitudeFinal}).then((response) => {
                  console.log("###Response : " + response);
                  var parsedData = JSON.parse(response);
                  this.windSpeed=parsedData.weatherObservation?parsedData.weatherObservation.windSpeed:'';
                  this.temperature=parsedData.weatherObservation?parsedData.weatherObservation.temperature:'';
                  this.humidity=parsedData.weatherObservation?parsedData.weatherObservation.humidity:'';
                  this.weatherCondition=parsedData.weatherObservation?parsedData.weatherObservation.weatherCondition:'';
                  this.htmlBody = "Hello, <br><br> Temperature Value : <font color=red><b>"+this.temperature+"°</b></font>.<br> wind speed Value : <font color=red><b>"+this.windSpeed+" Km/h</b></font>. <br> Humidity Value : <font color=red><b>"+this.humidity+"%</b></font>. <br> Weather condition Value : <font color=red><b>"+this.weatherCondition+"</b></font>";

          });
        }
        // send report and create activity 
        sendWetherReport() {
          sendWetherReport({ userId:Id,accountId:this.accountId,isAccount:this.isAccount,userEmail:this.currentUserEmail,htmlBody :this.htmlBody }).then((response) => {
            this.successSendReport();
          
    });
        }
        successSendReport() {
          const evt = new ShowToastEvent({
            title: 'Report send with success',
            message: 'Opearion sucessful',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
      }
       
        }