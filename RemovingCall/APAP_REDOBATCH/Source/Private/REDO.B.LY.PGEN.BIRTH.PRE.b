* @ValidationCode : MjotNjUwNjA5MzQzOkNwMTI1MjoxNjg0ODU0MzkwOTk4OklUU1M6LTE6LTE6MjU5ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2598
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.PGEN.BIRTH.PRE
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine is attached to the batch record BNK/REDO.B.LY.PGEN.BIRTH
*  This routine selects the necesary records from various files and updates it in temporary file
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 17-JUN-2013       RMONDRAGON   ODR-2011-06-0243      Initial Creation
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION -  VM TO @VM AND ++ TO += 1 
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.LY.MODALITY
    $INSERT I_F.REDO.LY.PDT.TYPE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_REDO.B.LY.PGEN.BIRTH.COMMON

    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB PROCESS.REDO.LY.MOD
    GOSUB WRITE.REDO.LY.PRG

RETURN

*----
INIT:
*----

    PRG.MOD.LST = ''         ; PRG.PER.MOD = '';
    PRG.LST = ''             ; PRG.ST.DATE.LST = '';
    PRG.END.DATE.LST = ''    ; PRG.DAYS.EXP.LST = '';
    PRG.EXP.DATE.LST = ''    ; PRG.CUS.GRP.LST = '';
    PRG.POINT.VALUE.LST = '' ; PRG.AVAIL.IF.DELAY.LST = '';
    PRG.POINT.USE.LST = ''   ; PRG.PTS.IN.MOD = '';
    PRG.PROD.LST = ''        ; PRG.COND.TYPE.EXINC = '';
    PRG.APP.EXC.COND = ''    ; PRG.EXC.EST.ACCT = '';
    PRG.APP.INC.COND = ''    ; PRG.INC.EST.ACCT = '';
    PRG.AIR.LST = ''         ; PRG.CCY.IN.MOD = '';
    PRG.RECSEL = ''

    VAR.T.GEN = 0; VAR.T.GEN.VALUE = 0
    VAR.T.AVAIL = 0; VAR.T.AVAIL.VALUE = 0
    VAR.T.NAVAIL = 0; VAR.T.NAVAIL.VALUE = 0

RETURN

*---------
OPEN.FILE:
*---------

    FN.REDO.LY.MODALITY = 'F.REDO.LY.MODALITY'
    F.REDO.LY.MODALITY = ''
    CALL OPF(FN.REDO.LY.MODALITY,F.REDO.LY.MODALITY)

    FN.REDO.LY.PDT.TYPE = 'F.REDO.LY.PDT.TYPE'
    F.REDO.LY.PDT.TYPE = ''
    CALL OPF(FN.REDO.LY.PDT.TYPE,F.REDO.LY.PDT.TYPE)

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.TEMP.LY.PGEN.BIRTH = 'F.TEMP.LY.PGEN.BIRTH'
    F.TEMP.LY.PGEN.BIRTH = ''
    OPEN FN.TEMP.LY.PGEN.BIRTH TO F.TEMP.LY.PGEN.BIRTH ELSE

        TEXT = 'Error in opening : ':FN.TEMP.LY.PGEN.BIRTH
        CALL FATAL.ERROR('REDO.B.LY.PGEN.BIRTH.PRE')
    END
    CLEARFILE F.TEMP.LY.PGEN.BIRTH

RETURN

*-------------------
PROCESS.REDO.LY.MOD:
*-------------------

    SEL.MOD = ''
    SEL.MOD = 'SSELECT ':FN.REDO.LY.MODALITY:' WITH EVENT EQ 4 AND TYPE EQ 6'
    MOD.LST = ''; NO.OF.MOD = 0; MOD.ERR = ''
    CALL EB.READLIST(SEL.MOD,MOD.LST,'',NO.OF.MOD,MOD.ERR)

    MOD.CNT = 1
    Y.SEARCH.PARAM = ''
    LOOP
    WHILE MOD.CNT LE NO.OF.MOD
        Y.MOD.SPEC = MOD.LST<MOD.CNT>
        PRG.MOD.LST<MOD.CNT> = Y.MOD.SPEC
        R.MOD = ''; MOD.ERR = ''
        CALL F.READ(FN.REDO.LY.MODALITY,Y.MOD.SPEC,R.MOD,F.REDO.LY.MODALITY,MOD.ERR)
        IF R.MOD THEN
            PRD.GRP = R.MOD<REDO.MOD.PRODUCT.GROUP>
            MOD.CCY = R.MOD<REDO.MOD.CURRENCY>
            GEN.PTS = R.MOD<REDO.MOD.GEN.POINTS>
            GOSUB GET.LY.PRODUCT.BY.GROUP
        END
        GOSUB PROCESS.REDO.LY.PRG
        MOD.CNT += 1
    REPEAT

RETURN

*-------------------
PROCESS.REDO.LY.PRG:
*-------------------

    SEL.PRG = 'SELECT ':FN.REDO.LY.PROGRAM:' WITH MODALITY EQ ':Y.MOD.SPEC:' AND STATUS EQ "Activo"'
    PROGRAM.LST = ''
    CALL EB.READLIST(SEL.PRG,PROGRAM.LST,'',NO.OF.PRG,PRG.ERR)

    PRG.PER.MOD<MOD.CNT> = NO.OF.PRG

    PRG.ID.CNT = 0
    LOOP
        REMOVE PRG.ID FROM PROGRAM.LST SETTING PRG.ID.POS
    WHILE PRG.ID:PRG.ID.POS
        PRG.ID.CNT += 1
        CALL F.READ(FN.REDO.LY.PROGRAM,PRG.ID,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PRG.ERR)
        IF R.REDO.LY.PROGRAM THEN
            PRG.LST<MOD.CNT,PRG.ID.CNT> = PRG.ID
            PRG.ST.DATE.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.START.DATE>
            PRG.END.DATE.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.END.DATE>
            PRG.DAYS.EXP.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.DAYS.EXP>
            PRG.EXP.DATE.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.EXP.DATE>
            PRG.CUS.GRP.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.GROUP.CUS>
            PRG.POINT.VALUE.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.POINT.VALUE>
            PRG.AVAIL.IF.DELAY.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.AVAIL.IF.DELAY>
            PRG.POINT.USE.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.POINT.USE>
            PRG.COND.TYPE.EXINC<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.COND.TYPE.EXINC>
            PRG.APP.EXC.COND<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.APP.EXC.COND>
            Y.TEMP.EXC.EST.ACCT = R.REDO.LY.PROGRAM<REDO.PROG.EXC.EST.ACCT>
            CHANGE @VM TO '*' IN Y.TEMP.EXC.EST.ACCT
            PRG.EXC.EST.ACCT<MOD.CNT,PRG.ID.CNT> = Y.TEMP.EXC.EST.ACCT
            PRG.APP.INC.COND<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.APP.INC.COND>
            Y.TEMP.INC.EST.ACCT = R.REDO.LY.PROGRAM<REDO.PROG.INC.EST.ACCT>
            CHANGE @VM TO '*' IN Y.TEMP.INC.EST.ACCT
            PRG.INC.EST.ACCT<MOD.CNT,PRG.ID.CNT> = Y.TEMP.INC.EST.ACCT
            PRG.AIR.LST<MOD.CNT,PRG.ID.CNT> = R.REDO.LY.PROGRAM<REDO.PROG.AIRL.PROG>

            PRG.PTS.IN.MOD<MOD.CNT,PRG.ID.CNT> = GEN.PTS
            PRG.PROD.LST<MOD.CNT,PRG.ID.CNT> = PROD.LST
            PRG.CCY.IN.MOD<MOD.CNT,PRG.ID.CNT> = MOD.CCY
        END
    REPEAT

RETURN

*-----------------------
GET.LY.PRODUCT.BY.GROUP:
*-----------------------

    CALL F.READ(FN.REDO.LY.PDT.TYPE,PRD.GRP,R.PDT.TYPE,F.REDO.LY.PDT.TYPE,PDT.TYPE.ERR)
    IF R.PDT.TYPE THEN
        PROD.LST = R.PDT.TYPE<REDO.PDT.PRODUCT>
        CHANGE @VM TO '*' IN PROD.LST
    END

RETURN

*-----------------
WRITE.REDO.LY.PRG:
*-----------------


*  WRITE PRG.MOD.LST TO F.TEMP.LY.PGEN.BIRTH,'MOD' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'MOD',PRG.MOD.LST) ;*Tus End

*  WRITE PRG.PER.MOD TO F.TEMP.LY.PGEN.BIRTH,'NOPRG' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'NOPRG',PRG.PER.MOD) ;*Tus End

*  WRITE PRG.LST TO F.TEMP.LY.PGEN.BIRTH,'PRG' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'PRG',PRG.LST);*Tus End

*  WRITE PRG.ST.DATE.LST TO F.TEMP.LY.PGEN.BIRTH,'ST.DATE' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'ST.DATE',PRG.ST.DATE.LST);*Tus End

*  WRITE PRG.END.DATE.LST TO F.TEMP.LY.PGEN.BIRTH,'END.DATE' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'END.DATE',PRG.END.DATE.LST);*Tus End

*  WRITE PRG.DAYS.EXP.LST TO F.TEMP.LY.PGEN.BIRTH,'DAYS.EXP' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'DAYS.EXP',PRG.DAYS.EXP.LST);*Tus End

*  WRITE PRG.EXP.DATE.LST TO F.TEMP.LY.PGEN.BIRTH,'EXP.DATE' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'EXP.DATE',PRG.EXP.DATE.LST);*Tus End

*  WRITE PRG.CUS.GRP.LST TO F.TEMP.LY.PGEN.BIRTH,'CUS.GROUP' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'CUS.GROUP',PRG.CUS.GRP.LST);*Tus End

*  WRITE PRG.POINT.VALUE.LST TO F.TEMP.LY.PGEN.BIRTH,'POINT.VALUE' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'POINT.VALUE',PRG.POINT.VALUE.LST);*Tus End

*  WRITE PRG.AVAIL.IF.DELAY.LST TO F.TEMP.LY.PGEN.BIRTH,'AVAIL.IF.DELAY' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'AVAIL.IF.DELAY',PRG.AVAIL.IF.DELAY.LST) ;*Tus End

*  WRITE PRG.POINT.USE.LST TO F.TEMP.LY.PGEN.BIRTH,'POINT.USE' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'POINT.USE',PRG.POINT.USE.LST);*Tus End

*  WRITE PRG.COND.TYPE.EXINC TO F.TEMP.LY.PGEN.BIRTH,'COND.TYPE.EXINC' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'COND.TYPE.EXINC',PRG.COND.TYPE.EXINC);*Tus End

*  WRITE PRG.APP.EXC.COND TO F.TEMP.LY.PGEN.BIRTH,'APP.EXC.COND' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'APP.EXC.COND',PRG.APP.EXC.COND);*Tus End

*  WRITE PRG.EXC.EST.ACCT TO F.TEMP.LY.PGEN.BIRTH,'EXC.EST.ACCT' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'EXC.EST.ACCT',PRG.EXC.EST.ACCT) ;*Tus End

*  WRITE PRG.APP.INC.COND TO F.TEMP.LY.PGEN.BIRTH,'APP.INC.COND' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'APP.INC.COND',PRG.APP.INC.COND) ;*Tus End

*  WRITE PRG.INC.EST.ACCT TO F.TEMP.LY.PGEN.BIRTH,'INC.EST.ACCT' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'INC.EST.ACCT',PRG.INC.EST.ACCT);*Tus End

*  WRITE PRG.AIR.LST TO F.TEMP.LY.PGEN.BIRTH,'AIR' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'AIR',PRG.AIR.LST);*Tus End


*  WRITE PRG.PTS.IN.MOD TO F.TEMP.LY.PGEN.BIRTH,'PTS.IN.MOD' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'PTS.IN.MOD',PRG.PTS.IN.MOD);*Tus End

*  WRITE PRG.PROD.LST TO F.TEMP.LY.PGEN.BIRTH,'PROD' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'PROD',PRG.PROD.LST) ;*Tus End

*  WRITE PRG.CCY.IN.MOD TO F.TEMP.LY.PGEN.BIRTH,'CCY.IN.MOD' ;*Tus Start
    CALL F.WRITE(FN.TEMP.LY.PGEN.BIRTH,'CCY.IN.MOD',PRG.CCY.IN.MOD) ; *Tus End

RETURN

END
