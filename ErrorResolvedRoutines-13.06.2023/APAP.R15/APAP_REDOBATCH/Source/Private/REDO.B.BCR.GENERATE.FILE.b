* @ValidationCode : MjotMTI0MTI0NzA3MzpDcDEyNTI6MTY4NTY4NzY4NTcxNTpJVFNTOi0xOi0xOjE4NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jun 2023 12:04:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BCR.GENERATE.FILE

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    
    $USING APAP.TAM
    $USING APAP.LAPAP

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

    FN.REDO.BCR.REPORT.EXEC='F.REDO.BCR.REPORT.EXEC'
    F.REDO.BCR.REPORT.EXEC=''
    CALL OPF(FN.REDO.BCR.REPORT.EXEC,F.REDO.BCR.REPORT.EXEC)

    ID.NEW.REC=BATCH.DETAILS<3,1,1>

    CALL F.READ(FN.REDO.BCR.REPORT.EXEC,ID.NEW.REC,R.REDO.BCR.REPORT.EXEC,F.REDO.BCR.REPORT.EXEC,Y.ERR)


    fieldName = ''
    R.REDO.INT.PARAM=''
    LOOP
        REMOVE fieldName FROM fieldNamesToCopy SETTING yPos
    WHILE fieldName : yPos
        fieldValue = ""
        fieldNoFrom    = 0
        APAP.TAM.tamRFieldNameToNumber("REDO.BCR.REPORT.EXEC", fieldName, fieldNoFrom)  ;*Manual R22 conversion
*        IF fieldNoFrom EQ 0 THEN
*            E    = "ST-REDO.BCR.FIELD.NON.EXIST"
*            E<2> = fieldName : VM : "REDO.INTERFACE.PARAM"
*            RETURN
*        END
        fieldNoTo = 0
        APAP.TAM.tamRFieldNameToNumber("REDO.INTERFACE.PARAM", fieldName, fieldNoTo)   ;*Manual R22 conversion
*       IF fieldNoTo EQ 0 THEN
*           E    = "ST-REDO.BCR.FIELD.NON.EXIST"
*           E<2> = fieldNoTo : VM : APPLICATION
*           RETURN
*       END
        R.REDO.INT.PARAM<fieldNoTo> = R.REDO.BCR.REPORT.EXEC<fieldNoFrom>
    REPEAT
*    RETURN

    CALL REDO.R.BCR.REPORT.BUILD(ID.NEW.REC,'ONLINE',R.REDO.INT.PARAM)
*APAP.LAPAP.redoRBcrReportBuild(ID.NEW.REC,'ONLINE',R.REDO.INT.PARAM) ;*Manual R22 conversion




RETURN


END
