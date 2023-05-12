* @ValidationCode : MjotMTEwNzM0NjU0MzpDcDEyNTI6MTY4Mzg2ODMwMzA4NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 10:41:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.EMAIL.SEND.R(R.EMAIL, Y.RESPONSE)
*-----------------------------------------------------------------------------
*** <region name= Description>
*** <desc>Description </desc>
* This subroutine allows to send an email through Java library T24TAMEmail
* Arguments:
* ----------
* R.EMAIL          - Email Information (@see I_TAM.EMAIL.COMMON)
* Y.EMAIL.INFO.XML - The record
*-----------------------------------------------------------------------------
* Here, it is an example R.EMAIL:
*
*      R.EMAIL<E_MAIL.PASSWORD> = "Temenos123"
*      R.EMAIL<E_MAIL.FROM> = "hpasquel@temenos.com"
*      R.EMAIL<E_MAIL.TO> = "paulpasquel@hotmail.com"
*      R.EMAIL<E_MAIL.TYPE> = "text/html"
*      R.EMAIL<E_MAIL.SUBJECT> = "It's an Subject"
*      R.EMAIL<E_MAIL.BODY> = "It's is the body"
*      R.EMAIL<E_MAIL.ATTACHMENT> = "EMAIL.BP/TAM.EMAIL.SEND.R" : VM : "EMAIL.BP/I_TAM.EMAIL.COMMON"
*
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TAM.EMAIL.COMMON

    GOSUB INITIALISE
    IF Y.RESPONSE EQ '' THEN
        GOSUB PROCESS
        GOSUB HANDLE.FAILURE
    END
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.RESPONSE = ''
    Y.EMAIL.INFO.XML = ''
*CALL TAM.EMAIL.CONVERT.XML.R(R.EMAIL, Y.EMAIL.INFO.XML, Y.RESPONSE)
** R22 Manual conversion
    CALL APAP.TAM.tamEmailConvertXmlR(R.EMAIL, Y.EMAIL.INFO.XML, Y.RESPONSE)
    
    IF Y.RESPONSE NE '' THEN
        RETURN
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

* One record with TAM.EMAIL.CLIENT must exist into EB.API
* The final method is postEmail in com.temenos.t24.tam.delivery.email.T24TAMEmailCarrierImpl
    Y.EB.AP.ID = "TAM.EMAIL.CLIENT"
    Y.CALLJ.ERROR = ''
    Y.RESPONSE    = ''
    CALL EB.CALL.JAVA.API(Y.EB.AP.ID, Y.EMAIL.INFO.XML, Y.RESPONSE, Y.CALLJ.ERROR)
* CALLJ "com.temenos.t24.tam.delivery.email.T24TAMEmailCarrierImpl", "postEmail", Y.EMAIL.INFO.XML SETTING ret
* Y.U = SYSTEM(0)

RETURN
*-----------------------------------------------------------------------------
HANDLE.FAILURE:
*-----------------------------------------------------------------------------
* Return the CALLJ error (if any)
    IF (Y.CALLJ.ERROR NE '') THEN
        Y.RESPONSE = 'Error in invoking Java interface - CALLJ error code :' : Y.CALLJ.ERROR
    END
    IF (Y.RESPONSE NE "") THEN
        Y.RESPONSE = 'STOP-':Y.RESPONSE
    END

RETURN
*-----------------------------------------------------------------------------
END
