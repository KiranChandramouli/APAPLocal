* @ValidationCode : MjotMTkxNTAyNTk5NjpDcDEyNTI6MTY4NDg1NDM5NTk3ODpJVFNTOi0xOi0xOjkyMjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 922
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REPORTE.ACTIVIDAD.POST
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
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00363969           Ashokkumar.V.P                 27/11/2014            Corrected the header and added format.
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND ++ TO += 1
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.REPORTE.ACTIVIDAD.COMMON
    $INSERT I_F.DATES

*
    GOSUB PROCESS.PARA
RETURN
************
PROCESS.PARA:
************
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
*
    Y.FINAL.REC = ''
    REDO.H.REPORTS.PARAM.ID = BATCH.DETAILS<3,1,1>
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,REDO.H.REPORTS.PARAM.ID,R.REDO.H.REPORTS.PARAM,REDO.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        TEMP.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END
*
    SEL.CMD = "SELECT ":TEMP.PATH:" LIKE ":FILE.NAME:"... AND WITH F1 NE '' SAVING UNIQUE F1"
    SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''
*
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
*
    Y.ACT.ECO.LIST = SEL.LIST
*
    GOSUB FORM.ACT.ECO.FIELD.1
*
    SEL.CMD1 = "SELECT ":TEMP.PATH:" LIKE ":FILE.NAME:"..."
    SEL.LIST1 = ''; NO.OF.RECS1 = ''; SEL.ERR1 = ''
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.RECS1,SEL.ERR1)
*
    GOSUB FORM.PRIN.INT.FIELD.2.4.6
    GOSUB FORM.PERCENTAGE.FIELDS.3.5.7
    GOSUB FORM.REC.WRITE.TO.FILE
    GOSUB DELETE.TEMP.RECORDS
RETURN
*********************
FORM.ACT.ECO.FIELD.1:
*********************
*
    Y.ACT.ECO.FLD.1 = ''
    Y.TOT.CNT = DCOUNT(SEL.LIST,@FM)
    FOR Y.CNT = 1 TO Y.TOT.CNT
        Y.LST.ID = SEL.LIST<Y.CNT>
        Y.LST.ID = "L.CR.FACILITY*":Y.LST.ID
        R.EB.LOOKUP = ''; ERR.LOOKUP = ''
        CALL F.READ(FN.EB.LOOKUP,Y.LST.ID,R.EB.LOOKUP,F.EB.LOOKUP,ERR.LOOKUP)
        IF R.EB.LOOKUP THEN
            Y.ACT.ECO.FLD.1<-1> = R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG>
        END
        Y.LST.ID = ''
    NEXT Y.CNT
RETURN
**************************
FORM.PRIN.INT.FIELD.2.4.6:
*************************
*
    Y.INT.FIELD.2 = '' ; Y.PRIN.FIELD.4 = '';Y.TOT.GEN.6 = ''
    Y.TOT.INT = ''; Y.TOT.PRIN = ''; Y.TOTAL.GEN = ''
*
    Y.TOT.CNT.REC = DCOUNT(SEL.LIST1,@FM)
    FOR Y.CNT1 = 1 TO Y.TOT.CNT.REC
        Y.REC.ID = SEL.LIST1<Y.CNT1>
        OPEN TEMP.PATH TO SEQ.PTR.READ THEN

            READ Y.REC FROM SEQ.PTR.READ,Y.REC.ID THEN

                CHANGE '|' TO @FM IN Y.REC
                Y.LST.ID =Y.REC<1>
                Y.INT.PART  = Y.REC<2>
                Y.PRIN.PART = Y.REC<3>
                LOCATE Y.LST.ID IN Y.ACT.ECO.LIST<1> SETTING POS THEN
                    Y.INT.FIELD.2<POS> + = Y.INT.PART
                    Y.PRIN.FIELD.4<POS> + = Y.PRIN.PART
                    Y.TOT.GEN.6<POS> + = Y.PRIN.PART + Y.INT.PART
                END
                Y.TOT.INT   = SUM(Y.INT.FIELD.2)
                Y.TOT.PRIN  = SUM(Y.PRIN.FIELD.4)
                Y.TOTAL.GEN = SUM(Y.TOT.GEN.6)
*
            END
        END
*
        Y.LST.ID ='' ;  Y.INT.PART =''; Y.PRIN.PART = ''
    NEXT Y.CNT1
RETURN
****************************
FORM.PERCENTAGE.FIELDS.3.5.7:
*****************************
*
    Y.PERC.3 = ''; Y.PERC.5 = ''; Y.PERC.7 = ''; Y.TOT.CNT.REC1 = ''
*
    Y.TOT.CNT.REC1 = DCOUNT(SEL.LIST1,@FM)
    FOR Y.CNT1 = 1 TO Y.TOT.CNT.REC1
        Y.REC.ID = SEL.LIST1<Y.CNT1>
        GOSUB FORM.PERCENTAGE.FIELDS.3.5.7.OPEN
        Y.LST.ID =''
    NEXT Y.CNT1
*
RETURN
**********************************
FORM.PERCENTAGE.FIELDS.3.5.7.OPEN:
**********************************
    OPEN TEMP.PATH TO SEQ.PTR.READ1 THEN

        READ Y.REC FROM SEQ.PTR.READ1,Y.REC.ID THEN

            CHANGE '|' TO @FM IN Y.REC
            Y.LST.ID =Y.REC<1>

            LOCATE Y.LST.ID IN Y.ACT.ECO.LIST<1> SETTING POS THEN
                Y.PERC.3<POS> = (Y.INT.FIELD.2<POS>/Y.TOT.INT)*100
                Y.PERC.5<POS> = (Y.PRIN.FIELD.4<POS>/Y.TOT.PRIN)*100
                Y.PERC.7<POS> = (Y.TOT.GEN.6<POS>/Y.TOTAL.GEN)*100
            END
        END
    END
*
RETURN
***********************
FORM.REC.WRITE.TO.FILE:
***********************
    Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.DATE  = ICONV(Y.TODAY,"D4")
    Y.DATE1 = OCONV(Y.DATE,"D4")
    CHANGE " " TO "-" IN Y.DATE1

    FILE.NAME = FILE.NAME:Y.TODAY:'.txt'
    Y.HEADER<-1> = 'Banco Central de la Republica Dominicana'
    Y.HEADER<-1> = 'Asociacion Popular de Ahorros y Prestamos'
    Y.HEADER<-1> = 'Fecha:':Y.DATE1
    Y.HEADER<-1> = ''
    Y.HEADER<-1> = 'Actividad_Economica|Intereses|Porcentaje_Intereses|Principal|Porcentaje_Principal|Total_General|Porcentaje_Total_General'
    Y.TOT.OUTPUT = Y.ACT.ECO.FLD.1:'|':Y.INT.FIELD.2:'|':Y.PERC.3:'|':Y.PRIN.FIELD.4:'|':Y.PERC.5:'|':Y.TOT.GEN.6:'|':Y.PERC.7
    GOSUB FORMAT.RECORD
*
    Y.TOT.OUTPUT = Y.HEADER:@FM:Y.FINAL.REC:@FM:Y.TOTAL
    CHANGE @FM TO CHARX(13):CHARX(10) IN Y.TOT.OUTPUT
*
    OPEN OUT.PATH TO OUT.PATH1 THEN

        WRITE Y.TOT.OUTPUT ON OUT.PATH1, FILE.NAME

    END
*
RETURN
********************
DELETE.TEMP.RECORDS:
********************
    LOOP
        REMOVE REC.ID2 FROM SEL.LIST1 SETTING SEL.POS2
    WHILE REC.ID2:SEL.POS2
        OPEN TEMP.PATH TO DEL.TEMP.PATH THEN

        END
        DELETE DEL.TEMP.PATH,REC.ID2

    REPEAT
RETURN
*************
FORMAT.RECORD:
**************

    Y.CNT.1 = 1
    LOOP
    WHILE Y.CNT.1 LE Y.TOT.CNT
        Y.INT.2.FLD  = FMT(Y.INT.FIELD.2<Y.CNT.1>,"R2#15")
        Y.PRIN.4.FLD = FMT(Y.PRIN.FIELD.4<Y.CNT.1>,"R2#15")
        Y.TOT.6.FLD  = FMT(Y.TOT.GEN.6<Y.CNT.1>,"R2#15")
        YY.ACT.ECO.FLD.1 = FMT(Y.ACT.ECO.FLD.1<Y.CNT.1>,"L#35")
        YY.PERC.3 = FMT(Y.PERC.3<Y.CNT.1>,"R3#6")
        YY.PERC.5 = FMT(Y.PERC.5<Y.CNT.1>,"R3#6")
        YY.PERC.7 = FMT(Y.PERC.7<Y.CNT.1>,"R3#6")
*        Y.FINAL.REC<-1> =  Y.ACT.ECO.FLD.1<Y.CNT.1>:'|':Y.INT.FIELD.2<Y.CNT.1>:'|':Y.PERC.3<Y.CNT.1>:'%|':Y.PRIN.FIELD.4<Y.CNT.1>:'|':Y.PERC.5<Y.CNT.1>:'%|':Y.TOT.GEN.6<Y.CNT.1>:'|':Y.PERC.7<Y.CNT.1>:'%'
        Y.FINAL.REC<-1> =  YY.ACT.ECO.FLD.1:'|':Y.INT.2.FLD:'|':YY.PERC.3:'%|':Y.PRIN.4.FLD:'|':YY.PERC.5:'%|':Y.TOT.6.FLD:'|':YY.PERC.7:'%'

        Y.CNT.1 += 1
    REPEAT
    Y.TOT.INT1 = FMT(Y.TOT.INT,"R2#15")
    Y.TOT.PRIN1 = FMT(Y.TOT.PRIN,"R2#15")
    Y.TOTAL.GEN1 = FMT(Y.TOTAL.GEN,"R2#15")
*    Y.TOTAL = 'Total general|':Y.TOT.INT:'|100%|':Y.TOT.PRIN:'|100%|':Y.TOTAL.GEN:'|100%'
    Y.TOTAL = 'Total General|':Y.TOT.INT1:'|100%|':Y.TOT.PRIN1:'|100%|':Y.TOTAL.GEN1:'|100%'
RETURN
END
