* @ValidationCode : MjoxNjEzMDUwODE4OkNwMTI1MjoxNjgxOTAwODY0OTUzOklUU1M6LTE6LTE6NzIwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 16:11:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 720
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RATE.CHANGE.EXTRACT
*-----------------------------------------------------------
* Description: This routine is attached to EB.PHANTOM application to
* extract the file as per the conditions defined.
*-----------------------------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
* 13.04.2023    Conversion Tool           R22                    Auto Conversion     - ++ TO += 1, FM TO @FM, VM TO @VM
* 13.04.2023    Shanmugapriya M           R22                    Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.REDO.RATE.CHANGE
    $INSERT I_F.REDO.MASSIVE.FILE.PATH

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------

    FN.REDO.RATE.CHANGE = 'F.REDO.RATE.CHANGE'
    F.REDO.RATE.CHANGE = ''
    CALL OPF(FN.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.MASSIVE.FILE.PATH = 'F.REDO.MASSIVE.FILE.PATH'
    F.REDO.MASSIVE.FILE.PATH = ''
    CALL OPF(FN.REDO.MASSIVE.FILE.PATH,F.REDO.MASSIVE.FILE.PATH)

    CALL CACHE.READ(FN.REDO.MASSIVE.FILE.PATH,'SYSTEM',R.FILE.DETAILS,F.REDO.MASSIVE.FILE.PATH)

    Y.EXTRACT.PATH   = R.FILE.DETAILS<MASS.FILE.EXTRACT.PATH>
    Y.UNPROCESS.PATH = R.FILE.DETAILS<MASS.FILE.UNPROCESSED.PATH>

    LOC.REF.APPLICATION="AA.PRD.DES.INTEREST"
    LOC.REF.FIELDS='L.AA.NXT.REV.DT':@VM:'L.AA.REV.FORM':@VM:'L.AA.FIR.REV.DT':@VM:'L.AA.REV.RT.TY'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.NXT.REV.DT = LOC.REF.POS<1,1>
    POS.L.AA.REV.FORM   = LOC.REF.POS<1,2>
    POS.L.AA.FIR.REV.DT = LOC.REF.POS<1,3>
    POS.L.AA.REV.RT.TY  = LOC.REF.POS<1,4>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.RATE.CHANGE:' WITH STATUS EQ UNPROCESSED'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.LOOP.CNT = 1
    LOOP
    WHILE Y.LOOP.CNT LE SEL.NOR
        Y.RATE.CHANGE.ID = SEL.LIST<Y.LOOP.CNT>
        CALL F.READ(FN.REDO.RATE.CHANGE,Y.RATE.CHANGE.ID,R.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE,RATE.ERR)
        IF R.REDO.RATE.CHANGE THEN
            GOSUB PROCESS.FILE.EXTRACT
        END
        Y.LOOP.CNT += 1         ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROCESS.FILE.EXTRACT:
*-----------------------------------------------------------------------------

    Y.PRODUCT = ''
    Y.RETURN.IDS = ''
    RETURN.AA.IDS = ''
    Y.PRODUCT.GROUP = R.REDO.RATE.CHANGE<REDO.RT.PRODUCT.GROUP>
    Y.PRODUCT       = R.REDO.RATE.CHANGE<REDO.RT.PRODUCT>
    Y.MARGIN.ID     = R.REDO.RATE.CHANGE<REDO.RT.MARGIN.ID>
    Y.FILE.TYPE     = R.REDO.RATE.CHANGE<REDO.RT.FILE.TYPE>
    Y.EXTRACT.TYPE  = R.REDO.RATE.CHANGE<REDO.RT.EXTRACT.TYPE>
    Y.FROM.DATE     = R.REDO.RATE.CHANGE<REDO.RT.FROM.DATE>
    Y.TO.DATE       = R.REDO.RATE.CHANGE<REDO.RT.TO.DATE>
    Y.REPLACE.OPTION= R.REDO.RATE.CHANGE<REDO.RT.REPLACE.OPTION>


    SEL.AA.CMD = 'SELECT ':FN.AA.ARRANGEMENT:' WITH PRODUCT.GROUP EQ ':Y.PRODUCT.GROUP
    IF Y.PRODUCT THEN
        CHANGE @VM TO ' ' IN Y.PRODUCT
        SEL.AA.CMD:=' AND WITH PRODUCT EQ ':Y.PRODUCT
    END
    SEL.AA.CMD :=' AND (ARR.STATUS EQ AUTH OR ARR.STATUS EQ CURRENT)'
    CALL EB.READLIST(SEL.AA.CMD,AA.IDS,'',NO.OF.REC,SEL.ERR)
    IF AA.IDS AND Y.EXTRACT.TYPE EQ 'AUTOMATICA' THEN
        GOSUB PROCESS.AUTO.IDS
    END
    IF AA.IDS AND Y.EXTRACT.TYPE EQ 'MANUAL' THEN
        GOSUB PROCESS.MANUAL.IDS
    END
    IF AA.IDS AND Y.EXTRACT.TYPE EQ '' THEN
        Y.AA.IDS.LIST = ''
        Y.VAR1 = 1
        LOOP
        WHILE Y.VAR1 LE NO.OF.REC
            ARR.ID = AA.IDS<Y.VAR1>

            GOSUB GET.INTEREST.CONDITION
            IF Y.LOAN.TYPE EQ 'BACK.TO.BACK' THEN
                Y.AA.IDS.LIST<-1> = ARR.ID
            END
            Y.VAR1 += 1                 ;** R22 Auto conversion - ++ TO += 1
        REPEAT
        IF Y.AA.IDS.LIST THEN
            CALL REDO.CHECK.MARGIN.IDS(Y.AA.IDS.LIST,Y.RATE.CHANGE.ID,Y.RETURN.IDS)
        END
    END

    IF Y.RETURN.IDS THEN
        CALL APAP.AA.REDO.CHECK.AA.IDS(Y.RETURN.IDS,RETURN.AA.IDS) ;* R22 Manual conversion - CALL method format changed
    END

    IF RETURN.AA.IDS THEN
        GOSUB FILE.CREATION
    END

    R.REDO.RATE.CHANGE<REDO.RT.STATUS> = 'PROCESSED'
*  WRITE R.REDO.RATE.CHANGE TO F.REDO.RATE.CHANGE,Y.RATE.CHANGE.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.RATE.CHANGE,Y.RATE.CHANGE.ID,R.REDO.RATE.CHANGE) ; * Tus End
    IF NOT(PGM.VERSION) AND NOT(RUNNING.UNDER.BATCH) THEN
        CALL JOURNAL.UPDATE('')
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS.AUTO.IDS:
*-----------------------------------------------------------------------------
    Y.AA.IDS.LIST = ''
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        ARR.ID = AA.IDS<Y.VAR1>

        GOSUB GET.INTEREST.CONDITION
        IF Y.NEXT.REVIEW.DATE GE Y.FROM.DATE AND Y.NEXT.REVIEW.DATE LE Y.TO.DATE AND Y.RATE.REVIEW.TYPE EQ 'AUTOMATICA' THEN
            Y.AA.IDS.LIST<-1> = ARR.ID
        END
        Y.VAR1 += 1          ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    IF Y.AA.IDS.LIST THEN
        CALL REDO.CHECK.MARGIN.IDS(Y.AA.IDS.LIST,Y.RATE.CHANGE.ID,Y.RETURN.IDS)
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS.MANUAL.IDS:
*-----------------------------------------------------------------------------

    Y.AA.IDS.LIST = ''
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        ARR.ID = AA.IDS<Y.VAR1>
        GOSUB GET.INTEREST.CONDITION
        IF Y.FROM.DATE AND Y.TO.DATE THEN
            IF Y.NEXT.REVIEW.DATE GE Y.FROM.DATE AND Y.NEXT.REVIEW.DATE LE Y.TO.DATE AND Y.NEXT.REVIEW.DATE AND Y.RATE.REVIEW.TYPE EQ 'MANUAL' THEN
                Y.AA.IDS.LIST<-1> = ARR.ID
            END
        END ELSE
            IF Y.NEXT.REVIEW.DATE EQ '' AND Y.RATE.REVIEW.TYPE EQ 'MANUAL' THEN
                Y.AA.IDS.LIST<-1> = ARR.ID
            END
        END
        Y.VAR1 += 1             ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    IF Y.AA.IDS.LIST THEN
        CALL REDO.CHECK.MARGIN.IDS(Y.AA.IDS.LIST,Y.RATE.CHANGE.ID,Y.RETURN.IDS)
    END
RETURN
*-----------------------------------------------------------------------------
FILE.CREATION:
*-----------------------------------------------------------------------------

*Y.OUT.ARRAY = 'Arrangement ID,Customer ID,Margin Operand,Proposed Spread Rate,Proposed Int Rate'
    Y.OUT.ARRAY = 'ID PRESTAMO,ID CLIENTE,TIPO OPERACION,TASA MARGEN,TASA INT PROPUESTA'
    Y.FINAL.IDS.CNT = DCOUNT(RETURN.AA.IDS,@FM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.FINAL.IDS.CNT

        Y.AA.ID = FIELD(RETURN.AA.IDS<Y.CNT>,'*',1)
        GOSUB GET.DETAILS
        Y.OUT.ARRAY<-1> = Y.AA.AC.ID:',':Y.CUS.ID:',':FIELD(RETURN.AA.IDS<Y.CNT>,'*',2):',':FIELD(RETURN.AA.IDS<Y.CNT>,'*',3):',':FIELD(RETURN.AA.IDS<Y.CNT>,'*',4)
        Y.CNT += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT

    GOSUB WRITE.FILE

RETURN
*-----------------------------------------------------------------
WRITE.FILE:
*-----------------------------------------------------------------

    IF Y.FILE.TYPE EQ 'MASSIVE' OR Y.FILE.TYPE EQ 'REPLACE' THEN
        Y.FILE.PATH = Y.UNPROCESS.PATH
    END
    IF Y.FILE.TYPE EQ 'EXTRACT' THEN
        Y.FILE.PATH = Y.EXTRACT.PATH
    END
    IF Y.FILE.TYPE EQ 'REPLACE' THEN
        Y.FILE.NAME = Y.FILE.TYPE:'.':Y.REPLACE.OPTION:'_':TODAY:'_':Y.RATE.CHANGE.ID:'.csv'
    END ELSE
        Y.FILE.NAME = Y.FILE.TYPE:'_':TODAY:'_':Y.RATE.CHANGE.ID:'.csv'
    END
    OPEN Y.FILE.PATH TO Y.FILE.PATH.WRITE THEN
        WRITE Y.OUT.ARRAY ON Y.FILE.PATH.WRITE,Y.FILE.NAME ON ERROR
            RETURN
        END
    END

RETURN
*-----------------------------------------------------------------
GET.DETAILS:
*-----------------------------------------------------------------

    IN.ACC.ID = ''
    IN.ARR.ID = Y.AA.ID
*CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
** R22 Manual conversion
    CALL APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
    Y.AA.AC.ID = OUT.ID

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    Y.CUS.ID = R.ARRANGEMENT<AA.ARR.CUSTOMER>
RETURN
*-----------------------------------------------------------------
GET.INTEREST.CONDITION:
*-----------------------------------------------------------------
    R.CONDITION.INTEREST = ''
    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
*CALL REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,PRIN.PROP,ERR)
** R22 Manual conversion
    CALL APAP.TAM.REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,PRIN.PROP,ERR)
    IF PRIN.PROP THEN
        EFF.DATE = TODAY
        PROP.CLASS='INTEREST'
        PROPERTY = PRIN.PROP
        R.CONDITION.INTEREST = ''
        ERR.MSG = ''
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.INTEREST,ERR.MSG)
** R22 Manual conversion
        CALL APAP.TAM.REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.INTEREST,ERR.MSG)
    END
    Y.FIRST.REVIEW.DATE =  R.CONDITION.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.FIR.REV.DT>
    Y.NEXT.REVIEW.DATE  =  R.CONDITION.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT>
    Y.RATE.REVIEW.TYPE  =  R.CONDITION.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.REV.FORM>
    Y.LOAN.TYPE         =  R.CONDITION.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.REV.RT.TY>

    IF Y.NEXT.REVIEW.DATE ELSE
        Y.NEXT.REVIEW.DATE = Y.FIRST.REVIEW.DATE
    END

RETURN
END
