*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.M.PROP.NONRES.POST
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .POST Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*
*-------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.M.PROP.NONRES.COMMON

    GOSUB PROCESS.PARA
    RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*
*
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    FILE.NAME = ''

    Y.BODY = ''; Y.HDR = ''; Y.FTR = ''

    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END

    SEL.CMD = "SELECT ":TEMP.PATH:" LIKE ":FILE.NAME:"..."
    SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CNT = 1
    LOOP
    WHILE CNT LE NO.OF.RECS
        REC.ID = SEL.LIST<CNT>
        OPEN TEMP.PATH TO SEQ.PTR.READ THEN
            READ R.TEMP.PATH FROM SEQ.PTR.READ,REC.ID THEN
                Y.BODY<-1> = R.TEMP.PATH
            END
        END
        OPEN TEMP.PATH TO SEQ.PTR.DEL THEN
            DELETE SEQ.PTR.DEL,REC.ID
        END
        CNT = CNT + 1
    REPEAT

    Y.HDR<-1> = 'BANCO CENTRAL DE LA REPUBLICA DOMINICANA'
    Y.HDR<-1> = 'FORMULARIO DE ESTADISTICAS PARA EL REGISTRO DE INMUEBLES ADQUIRIDOS POR INSTITUCIONES Y/O PERSONAS NACIONALES O EXTRANJERAS RESIDENTES EN EL EXTERIOR'
    Y.HDR<-1> = 'Asociación Popular de Ahorros y Préstamos'
    Y.HDR<-1> = '809-689-0171'
    Y.HDR<-1> = 'Captar ahorros y otorgar préstamos hipotecarios'
    Y.HDR<-1> = ''

    Y.FTR<-1> = ''
    Y.FTR<-1> = ''
    Y.FTR<-1> = ''
    Y.FTR<-1> = ''
    Y.FTR<-1> = ''
    Y.FTR<-1> = ''
    Y.FTR<-1> = ''
    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    FILE.NAME = FILE.NAME:Y.TODAY:'.txt'
    Y.FINAL.ARRAY = Y.HDR:FM:Y.BODY:FM:Y.FTR
    CHANGE FM TO CHARX(13):CHARX(10) IN Y.FINAL.ARRAY
    OPEN OUT.PATH TO OUT.PATH1 THEN
        WRITE Y.FINAL.ARRAY TO OUT.PATH1,FILE.NAME
    END
*
    RETURN
END
