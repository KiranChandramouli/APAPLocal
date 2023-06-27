* @ValidationCode : MjotNjExMDAxMzEwOkNwMTI1MjoxNjg0ODQyMTU2MjE5OklUU1M6LTE6LTE6NDkxOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 491
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.EMAIL.SEND.TEST
*-----------------------------------------------------------------------------
* This an example about how to use the TAM.EMAIL.SEND.R routine to send an email
* with an attachments
* For exexuting this you must create a PGM.FILE with type = M
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_TAM.EMAIL.COMMON

    LOOP
*CRT "INPUST EMAIL ADDRESS TO"
*INPUT toEmail
        Y.ER = ""
        CALL EB.VALIDATE.EMAIL.ADDRESS(toEmail, Y.ER)
        IF Y.ER NE "" THEN
            PRINT Y.ER
        END
    WHILE Y.ER NE ""
    REPEAT

    R.EMAIL = ""
    R.EMAIL<E_MAIL.PASSWORD> = ""
    R.EMAIL<E_MAIL.FROM> = "GAORTEGA@apap.com.do"
    R.EMAIL<E_MAIL.TO> = "rmercedes@apap.com.do"
    R.EMAIL<E_MAIL.TYPE> = "His"
    R.EMAIL<E_MAIL.SUBJECT> = "Prueba de correo"
    R.EMAIL<E_MAIL.BODY> = "It's is the body"
* DIR.PATH + FILE.NAME
    R.EMAIL<E_MAIL.ATTACHMENT> = "/T24/areas/t24bbcr9/bnk/bnk.interface/BCR/datacredito/burocredito.lst"

    Y.ERROR = ""

* Just for test the conversion to XML
*   Y.EMAIL.INFO.XML = ""
*   CALL TAM.EMAIL.CONVERT.XML.R(R.EMAIL, Y.EMAIL.INFO.XML, Y.ERROR)
*   CRT Y.EMAIL.INFO.XML

*CALL TAM.EMAIL.SEND.R(R.EMAIL, Y.ERROR)
** R22 Manual conversion
    APAP.TAM.tamEmailSendR(R.EMAIL, Y.ERROR)
    
    CRT ""
    
    CRT "Routine rertuns : " :Y.ERROR
    CRT "<press ENTER to continue>"
    INPUT Y.ERROR
END
