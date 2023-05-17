SUBROUTINE REDO.B.BCR.GENERATE.FILE

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


    CALL REDO.R.BCR.REPORT.BUILD(ID.NEW.REC,'ONLINE',R.REDO.INT.PARAM)




RETURN


END
