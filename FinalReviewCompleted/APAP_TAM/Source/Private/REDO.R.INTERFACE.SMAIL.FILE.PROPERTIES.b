* @ValidationCode : MjoxODYzNDcwMzYwOkNwMTI1MjoxNjgwOTQwNzEzMDYyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Apr 2023 13:28:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.INTERFACE.SMAIL.FILE.PROPERTIES
*-----------------------------------------------------------------------------
*
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
* @description  Esta rutina es invocada desde la aplicaci�n REDO.INTERFACE.SMAIL,
*               cada vez que se ha realizado una autorizaci�n sobre el INPUT o modificaci�n
*               del registro con identificador SYSTEM. El prop�sito de esta rutina es crear
*               o actualizar el archivo de propiedades T24TAMEmail.properties en el directorio
*               ..bnk.run\jars\T24TAMemail\config
* @More info:   http://java.sun.com/products/javamail/javadocs/com/sun/mail/smtp/package-summary.html
* @parametes
*             R.NEW       (in)  obtiene la informacion a grabar
*             E           (out) Message in case of Error
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.REDO.INTERFACE.SMAIL

*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    OPENSEQ yPath, yPropFile TO F.PROP.FILE ELSE
        CREATE F.PROP.FILE ELSE
            AF = 1
            E    = "ST-REDO.BCR.PROPERTY.NOT.FOUND"
            E<2> = yPropFile : @VM : yPath
            RETURN
        END
    END


* Header
    yLine = "# --------------------------------------------"
    GOSUB WRITE.LINE
    yLine = "# Properties for library T24TAMEmail.jar "
    GOSUB WRITE.LINE
    yLine = "# --------------------------------------------"
    GOSUB WRITE.LINE
    yLine = "# last update: " : TIMEDATE()
    GOSUB WRITE.LINE
    yLine = "# file Name  : " : yPath : '/' : yPropFile
    GOSUB WRITE.LINE
    yLine = "# authorizer : " : OPERATOR
    GOSUB WRITE.LINE
    yLine = "# --------------------------------------------"
    GOSUB WRITE.LINE

* Properties
    yLine = "mail.transport.protocol=smtp"
    GOSUB WRITE.LINE
    yLine = "mail.smtp.host=" : R.NEW(REDO.INT.SMAIL.IP.ADDRESS)
    GOSUB WRITE.LINE
    yLine = "mail.smtp.port=" : R.NEW(REDO.INT.SMAIL.PORT)
    GOSUB WRITE.LINE
    yLine = "mail.smtp.auth="
    IF R.NEW(REDO.INT.SMAIL.AUTH.REQUIRED) EQ 'SI' THEN
        yLine := "true"
    END ELSE
        yLine := "false"
    END
    GOSUB WRITE.LINE
    yLine = "mail.smtp.user=" : R.NEW(REDO.INT.SMAIL.USERNAME)
    GOSUB WRITE.LINE
    sslEnabled = R.NEW(REDO.INT.SMAIL.SSL.ENABLE)

* I tested this configuration with gmail
    IF sslEnabled EQ 'SI' THEN
        yLine = "mail.smtp.ssl.enable=true" :
        GOSUB WRITE.LINE
        yLine = "mail.smtp.socketFactory.class=javax.net.ssl.SSLSocketFactory" :
        GOSUB WRITE.LINE
    END
    yLine = "# --------------------------------------------"
    GOSUB WRITE.LINE
    yLine = "# File ends here"
    GOSUB WRITE.LINE

    WEOFSEQ  F.PROP.FILE        ;* Writes an EOF

    CLOSESEQ F.PROP.FILE




RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    yPath     = R.NEW(REDO.INT.SMAIL.PROP.FILE.PATH)          ;*'./jars/T24TAMEmail/config'
    yPropFile = R.NEW(REDO.INT.SMAIL.PROP.FILE)     ;*'t24tamemail.properties'

RETURN

*-----------------------------------------------------------------------------
WRITE.LINE:
*-----------------------------------------------------------------------------
    WRITESEQ yLine TO F.PROP.FILE ELSE
        E = "ST-REDO.BCR.CANT.WRITE"
        E<2> =  F.PROP.FILE
    END
RETURN

*-----------------------------------------------------------------------------
END
