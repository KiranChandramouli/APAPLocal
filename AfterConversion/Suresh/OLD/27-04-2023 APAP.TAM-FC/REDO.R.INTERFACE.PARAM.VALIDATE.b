* @ValidationCode : MjotMzE1Nzk1ODE4OkNwMTI1MjoxNjgyNDk0NTMyMTk2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 13:05:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.R.INTERFACE.PARAM.VALIDATE(tableName)
*-----------------------------------------------------------------------------
* This routine will validate the entries into REDO.INTERFACE.PARAM and
* REDO.BCR.REPORT.EXEC. It is called in VALIDATION stage
* @author hpasquel@temenos.com
* @package infra.eb
*
* @parameters
*           tableName    (in) Current Application. REDO.INTERFACE.PARAM or REDO.BCR.REPORT.EXEC
* INPUT / OUTPUT
* ---------------
*           R.NEW        (in)  Current info to validate
*           ETEXT       (out)  Message in case of error
*           AF          (out)  Field Position where the message will be showed
*           AV          (out)  Value Position where the message will be showed
*
* This routines does not call to STORE.END.ERROR
*
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------
* 28/09/10 - APAP C.21 Buro de Credito
*            Creation
* 17.04.12 - PACS00191153  - Code Review
*            hpasquel@temenos.com
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
*
    GOSUB INITIALISE
    GOSUB PROCESS
    ETEXT = Y.E.TEXT  ;* Avoid that Code Review Tool, catch no relevant issues
RETURN
*** </region>
*** <region name= Initialise>
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.RAD = 'F.RAD.CONDUIT.LINEAR'
    F.RAD  = ''
    CALL OPF(FN.RAD, F.RAD)

    sendMethod = ""
    sendMethodNo = 0
    CALL APAP.TAM.TAM.R.GET.VALUE.BY.FIELD.NAME(tableName, "SEND.METHOD", MAT R.NEW, sendMethod, sendMethodNo) ;*MANUAL R22 CODE CONVERSION

RETURN
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Process>
PROCESS:
*-----------------------------------------------------------------------------
***
* what is the content of encriptation
    encriptation = ""

    mandatoryFields = ""
    mandatoryFields<-1> = "SEND.METHOD"
    mandatoryFields<-1> = "DIR.PATH"
    mandatoryFields<-1> = "FILE.NAME"
* Just for MAIN parameters file
    IF tableName EQ 'REDO.INTERFACE.PARAM' THEN
        mandatoryFields<-1> = "AUTOM.EXEC"
        mandatoryFields<-1> = "AUTOM.EXEC.FREC"
    END
    mandatoryFields<-1> = "ENCRIPTATION"

    Y.E.TEXT = ""
    LOOP
        REMOVE fieldName FROM mandatoryFields SETTING yPos
    WHILE fieldName : yPos AND Y.E.TEXT EQ ""

        Y.TO.MATCH = "SEND.METHOD" : @VM : "DIR.PATH" : @VM : "FILE.NAME" : @VM : "AUTOM.EXEC"
        fieldValue = ""
        fieldNo    = 0
* After this IF we have fieldValue and fieldNo of the current FIELD to check
        IF fieldName MATCHES Y.TO.MATCH THEN
            GOSUB CHECK.FIELD.MANDATORY
            IF Y.E.TEXT NE "" THEN
                RETURN
            END
        END ELSE
            CALL APAP.TAM.TAM.R.GET.VALUE.BY.FIELD.NAME(tableName, fieldName, MAT R.NEW, fieldValue, fieldNo) ;*MANUAL R22 CODE CONVERSION
        END

        BEGIN CASE
            CASE fieldName EQ "SEND.METHOD"
                IF NOT(fieldValue MATCHES "FTP" : @VM : "EMAIL") THEN
                    AF = fieldNo
                    Y.E.TEXT = "ST-REDO.BCR.NOT.PERMITED.VALUE"
                    Y.E.TEXT<2> = fieldName
                END


            CASE fieldName EQ "DIR.PATH"
                CALL BR.CREATE.PATH("CHECK.PATH", fieldValue)
                AF = fieldNo
                AV = 1

            CASE fieldName EQ "AUTOM.EXEC" AND fieldValue EQ "SI"
                fieldName = "AUTOM.EXEC.FREC"
                GOSUB CHECK.FIELD.MANDATORY

            CASE fieldName EQ "AUTOM.EXEC.FREC" AND fieldValue NE ""
                automExecFrec = fieldValue[1,8]
                IF automExecFrec LT TODAY THEN
                    AF = fieldNo
                    Y.E.TEXT = 'ST-REDO.BCR.INVALID.DATE'
                END

            CASE fieldName EQ "ENCRIPTATION"
* Initialise variable encriptation
                encriptation = fieldValue
                IF fieldValue NE "SI" AND sendMethod EQ "EMAIL" THEN
                    AF = fieldNo
                    Y.E.TEXT = 'ST-REDO.BCR.ENCRYPT.FIELD.VALIDATION'
                END

        END CASE
    REPEAT

    IF Y.E.TEXT NE "" THEN
        RETURN
    END

* In case of encryption is needed, check related values
    IF encriptation EQ 'SI' THEN

* <<
        fieldName = "ENCRIP.KEY"
        GOSUB CHECK.FIELD.MANDATORY
        IF Y.E.TEXT NE "" THEN
            RETURN
        END

        noBytes = BYTELEN(fieldValue)
* 128/8
        minBytes = 16
        IF noBytes LT minBytes THEN
            AF = fieldNo
            Y.E.TEXT = "ST-REDO.BCR.MINIMUM.CHARACTERES.PASS" : @FM : minBytes
            RETURN
        END
* >>

* << Check Method to use
        fieldName = "ENCRIP.MET"
        GOSUB CHECK.FIELD.MANDATORY
        IF Y.E.TEXT NE "" THEN
            RETURN
        END
        IF fieldValue NE '3DES' THEN
            AF = fieldNo
            Y.E.TEXT = "ST-REDO.BCR.VALID.METHOD.ENCRYPTATION"
            Y.E.TEXT<2> = '3DES'
            RETURN
        END
* >>
    END

* Checks values on PARAM.VALUE
    GOSUB CHECK.PARAMTYPE


*
RETURN
*** </region>
*** <region name= checkFieldMandatory>
*** fieldName  (in)  name of the field to check
*** fieldValue (out) content of the field
*** fieldNo    (out) position of the field
*-----------------------------------------------------------------------------
CHECK.FIELD.MANDATORY:
*-----------------------------------------------------------------------------
    fieldValue = ""
    fieldNo    = 0
    CALL APAP.TAM.TAM.R.GET.VALUE.BY.FIELD.NAME(tableName, fieldName, MAT R.NEW, fieldValue, fieldNo) ;*MANUAL R22 CODE CONVERSION
    IF fieldValue EQ "" THEN
        AF = fieldNo
        Y.E.TEXT = "ST-REDO.BCR-MANDATORY-FIELD"
        Y.E.TEXT<2> = fieldName
    END

RETURN
*** </region>
*** <region name= checkParameter>
*-----------------------------------------------------------------------------
CHECK.PARAMTYPE:
*-----------------------------------------------------------------------------
* PARAM.TYPE field
    fieldParamType     = ""
    fieldParamTypeNo   = 0
    fieldName          = "PARAM.TYPE"
    CALL APAP.TAM.TAM.R.GET.VALUE.BY.FIELD.NAME(tableName, fieldName,  MAT R.NEW, fieldParamType, fieldParamTypeNo) ;*MANUAL R22 CODE CONVERSION

* PARAM.VALUE field
    fieldParamValue    = ""
    fieldParamValueNo  = 0
    fieldName          = "PARAM.VALUE"
    CALL APAP.TAM.TAM.R.GET.VALUE.BY.FIELD.NAME(tableName, fieldName,  MAT R.NEW, fieldParamValue, fieldParamValueNo) ;*MANUAL R22 CODE CONVERSION


* Check Dup on some paramTypes
    GOSUB CHECK.DUP.PARAM.TYPE
    IF Y.E.TEXT NE "" THEN
        RETURN
    END

* Main validations for each paramType Field
    paramTypeToCheckList = ""
    paramTypeToCheckList<-1> = "FILE.FORMAT"
    paramTypeToCheckList<-1> = "PATH.SUCCESS"
    paramTypeToCheckList<-1> = "PATH.FAILURE"
    paramTypeToCheckList<-1> = "FTP.LISTENER.PATH"
    paramTypeToCheckList<-1> = "TO"
    paramTypeToCheckList<-1> = "CC"
    paramTypeToCheckList<-1> = "FROM"

    Y.E.TEXT = ""
    LOOP
        REMOVE paramTypeToCheck FROM paramTypeToCheckList SETTING yPos
    WHILE paramTypeToCheck : yPos AND Y.E.TEXT EQ ""
* Content
        paramValue = ""
* PARAM.TYPE to check
        paramType = paramTypeToCheck
* Position the PARAM.TYPE
        valueNo = 0
        AV = 1
        GOSUB GET.PARAM.TYPE.VALUE
        GOSUB CHECK.PARAM.VALUE
        GOSUB CHECK.IF.PATH.EXISTS
    REPEAT

RETURN
*-----------------------------------------------------------------------------
*** </region>
*** <region name= getParamTypeValue>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

    valueNo = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
RETURN


*-----------------------------------------------------------------------------
*** </region>
*** <region name= checkFieldMandatory>
*-----------------------------------------------------------------------------
CHECK.PARAM.TYPE.MANDATORY:
*-----------------------------------------------------------------------------

    IF paramValue EQ "" OR valueNo EQ 0 THEN
        AF = fieldParamTypeNo
        AV = 1
        IF valueNo GT 0 THEN
            AV = valueNo
        END
        Y.E.TEXT = "ST-REDO.BCR-MANDATORY-FIELD"
        Y.E.TEXT<2> = paramType
    END

RETURN
*** </region>
*** <region name= checkDupParamType>
*-----------------------------------------------------------------------------
CHECK.DUP.PARAM.TYPE:
*-----------------------------------------------------------------------------
    paramTypeToCheckList = ""
    paramTypeToCheckList<-1> = "FILE.FORMAT"
    paramTypeToCheckList<-1> = "PATH.SUCCESS"
    paramTypeToCheckList<-1> = "PATH.FAILURE"
    paramTypeToCheckList<-1> = "FTP.LISTENER.PATH"

    LOOP
        REMOVE paramTypeToCheck FROM paramTypeToCheckList SETTING yPos
    WHILE paramTypeToCheck : yPos
        result = 0
* CALL TAM.R.CHECK.DUP.VALUES(paramTypeToCheck, fieldParamType, @VM, result)
** R22 Manual conversion
        CALL APAP.TAM.TAM.R.CHECK.DUP.VALUES(paramTypeToCheck, fieldParamType, @VM, result)
        IF result GT 0 THEN
            AF =  fieldParamTypeNo
            AV =  result
            Y.E.TEXT = "ST-REDO.BCR.DUPLICATE.PARAM"
            Y.E.TEXT<2> = paramTypeToCheck
            RETURN
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
*** </region>
*** <region name= CHECK.PARAM.VALUE>
*-----------------------------------------------------------------------------
CHECK.PARAM.VALUE:
*-----------------------------------------------------------------------------
    BEGIN CASE
* FILE.FORMAT
* ------------------------------
        CASE paramType EQ "FILE.FORMAT"
            GOSUB CHECK.FILE.FORMAT
* PATCH.SUCESSS, PATH.FAILURE
* ------------------------------
        CASE sendMethod EQ "EMAIL" AND paramType MATCHES "PATH.SUCCESS" : @VM : "PATH.FAILURE"
            GOSUB CHECK.PARAM.TYPE.MANDATORY

* FTP.LISTENER.PATH
* ------------------------------
        CASE sendMethod EQ "FTP" AND  paramType EQ "FTP.LISTENER.PATH"
            GOSUB CHECK.PARAM.TYPE.MANDATORY

* TO, CC, FROM
* ------------------------------
        CASE paramType MATCHES "TO" : @VM : "CC" : @VM : "FROM"
            GOSUB CHECK.FROM.TO.EMAIL
    END CASE

RETURN
*** </region>
*** <region name= CHECK.FROM.TO.EMAIL>
*-----------------------------------------------------------------------------
CHECK.FROM.TO.EMAIL:
*-----------------------------------------------------------------------------
    IF sendMethod EQ "EMAIL" AND paramType EQ "TO" THEN
        GOSUB CHECK.PARAM.TYPE.MANDATORY
    END

    IF paramValue NE "" THEN
        Y.E.TEXT = ""
        CALL EB.VALIDATE.EMAIL.ADDRESS(paramValue, Y.E.TEXT)
        AF = fieldParamValueNo
        IF valueNo GT 0 THEN
            AV = valueNo
        END
    END
RETURN
*** </region>
*** <region name= CHECK.FILE.FORMAT>
*-----------------------------------------------------------------------------
CHECK.FILE.FORMAT:
*-----------------------------------------------------------------------------
    GOSUB CHECK.PARAM.TYPE.MANDATORY
    IF Y.E.TEXT EQ ""  AND paramValue[1,3] NE "BCR" THEN
        AF = fieldParamTypeNo
        IF valueNo GT 0 THEN
            AV = valueNo
        END
        Y.E.TEXT = "ST-REDO.BCR-BEGIN.WITH.BCR"
        RETURN
    END
    R.RAD = ""
    CALL F.READ(FN.RAD, paramValue, R.RAD, F.RAD, errMsg)
    IF R.RAD EQ "" THEN
        AF = fieldParamTypeNo
        IF valueNo GT 0 THEN
            AV = valueNo
        END
        Y.E.TEXT = "ST-REDO.BCR.FILE.FORMAT.NOT.FOUND"
        Y.E.TEXT<2> = paramValue
    END
RETURN
*** </region>
*** <region name= CHECK.IF.PATH.EXISTS>
*-----------------------------------------------------------------------------
CHECK.IF.PATH.EXISTS:
*-----------------------------------------------------------------------------
* Check if the path exists
    Y.TO.MATCH = "PATH.SUCCESS" : @VM : "PATH.FAILURE" : @VM : "FTP.LISTENER.PATH"
    IF Y.E.TEXT EQ "" AND paramType MATCHES  Y.TO.MATCH THEN
        IF paramValue NE "" THEN
            CALL BR.CREATE.PATH("CHECK.PATH", paramValue)
            AF = fieldParamValueNo
            IF valueNo GT 0 THEN
                AV = valueNo
            END
        END
    END
RETURN
*** </region>
*-----------------------------------------------------------------------------
END
