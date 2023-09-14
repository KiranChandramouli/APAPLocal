* @ValidationCode : MjotOTU4OTk0NDE1OkNwMTI1MjoxNjgwNzkwMTA3MDIxOklUU1M6LTE6LTE6MTg4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 188
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
        CALL TAM.R.FIELD.NAME.TO.NUMBER("REDO.BCR.REPORT.EXEC", fieldName, fieldNoFrom)
*        IF fieldNoFrom EQ 0 THEN
*            E    = "ST-REDO.BCR.FIELD.NON.EXIST"
*            E<2> = fieldName : VM : "REDO.INTERFACE.PARAM"
*            RETURN
*        END
        fieldNoTo = 0
        CALL TAM.R.FIELD.NAME.TO.NUMBER("REDO.INTERFACE.PARAM", fieldName, fieldNoTo)
*       IF fieldNoTo EQ 0 THEN
*           E    = "ST-REDO.BCR.FIELD.NON.EXIST"
*           E<2> = fieldNoTo : VM : APPLICATION
*           RETURN
*       END
        R.REDO.INT.PARAM<fieldNoTo> = R.REDO.BCR.REPORT.EXEC<fieldNoFrom>
    REPEAT
*    RETURN


    CALL APAP.LAPAP.REDO.R.BCR.REPORT.BUILD(ID.NEW.REC,'ONLINE',R.REDO.INT.PARAM) ;*Manual R22 conversion




RETURN


END
