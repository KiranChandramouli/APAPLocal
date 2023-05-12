* @ValidationCode : MjotNzA1ODI2OTU0OkNwMTI1MjoxNjgzODA5MTY1MDY1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 May 2023 18:16:05
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
SUBROUTINE REDO.R.BCR.REP.COPY.PARAM(redoIntParamID)
*-----------------------------------------------------------------------------
* Allows to copy the content from REDO.INTERFACE.PARAM to the R.NEW array
* It will be called from REDO.BCR.REPORT.EXEC application
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
* @parameters
*          redoIntParam  (in)        Identifier from REDO.INTERFACE.PARAM to copy
*          R.NEW         (out)       Common variable, where the values will be copied
*          E             (out)       Common variable with message in case of Error

** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    IF E NE "" THEN
        RETURN
    END
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    fieldName = ''
    LOOP
        REMOVE fieldName FROM fieldNamesToCopy SETTING yPos
    WHILE fieldName : yPos
        fieldValue = ""
        fieldNoFrom    = 0
*CALL APAP.TAM.TAM.R.FIELD.NAME.TO.NUMBER("REDO.INTERFACE.PARAM", fieldName, fieldNoFrom) ;*MANUAL R22 CODE CONVERSION
        CALL APAP.TAM.tamRFieldNameToNumber("REDO.INTERFACE.PARAM", fieldName, fieldNoFrom) ;*MANUAL R22 CODE CONVERSION
        IF fieldNoFrom EQ 0 THEN
            E    = "ST-REDO.BCR.FIELD.NON.EXIST"
            E<2> = fieldName : @VM : "REDO.INTERFACE.PARAM"
            RETURN
        END
        fieldNoTo = 0
        CALL APAP.TAM.tamRFieldNameToNumber(APPLICATION, fieldName, fieldNoTo) ;*MANUAL R22 CODE CONVERSION
        IF fieldNoTo EQ 0 THEN
            E    = "ST-REDO.BCR.FIELD.NON.EXIST"
            E<2> = fieldNoTo : @VM : APPLICATION
            RETURN
        END
        R.NEW(fieldNoTo) = R.REDO.INT.PARAM(fieldNoFrom)
    REPEAT
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

* Parameter Validations
    IF redoIntParamID EQ "" THEN
        E = "ST-REDO.BCR.PARAM.REDOINTID.REQUIRED"
        E<2>  = "redoIntParamID" : @VM : "REDO.R.BCR.REP.COPY.PARAM"
        RETURN
    END

* Open the record from REDO.INTERFACE.PARAM
    FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INT.PARAM  = ''
    CALL OPF(FN.REDO.INT.PARAM, F.REDO.INT.PARAM)

    DIM R.REDO.INT.PARAM(C$SYSDIM)
    yErrMsg = ''
    CALL F.MATREAD(FN.REDO.INT.PARAM, redoIntParamID, MAT R.REDO.INT.PARAM, C$SYSDIM, F.REDO.INT.PARAM, yErrMsg)

    IF yErrMsg NE '' THEN
        E = "ST-REDO.BCR.RECORD.NOT.FOUND"
        E<2> = redoIntParamID :@VM: 'REDO.INTERFACE.PARAM'
        RETURN
    END

* List of Fields to copy
    fieldNamesToCopy = ''
    fieldNamesToCopy<-1> = 'NAME'
    fieldNamesToCopy<-1> = 'SEND.METHOD'
    fieldNamesToCopy<-1> = 'ENCRIPTATION'
    fieldNamesToCopy<-1> = 'ENCRIP.KEY'
    fieldNamesToCopy<-1> = 'ENCRIP.MET'
    fieldNamesToCopy<-1> = 'DIR.PATH'
    fieldNamesToCopy<-1> = 'FILE.NAME'
    fieldNamesToCopy<-1> = 'PARAM.TYPE'
    fieldNamesToCopy<-1> = 'PARAM.VALUE'
RETURN

*-----------------------------------------------------------------------------
END
