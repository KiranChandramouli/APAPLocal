* @ValidationCode : MjotMzUxNzk5OTcyOkNwMTI1MjoxNjgzMDI0MzM1NTU2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:35
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

SUBROUTINE REDO.VAL.DEF.BAL.MAIN.TOT
*-------------------------------------------------------------------------------------------------------
* DESCRIPTION : This pre validation routine is used for to adjust balances in balance maintenance property
*-------------------------------------------------------------------------------------------------------
*IN : N/A
*OUT : N/A
*-------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date                 Developer               Reference                  Description
*--------             ------------             ----------                 ------------
*24-10-2017           Edwin Charles D          PACS00629274             REDO.ADJUST.BILLS activity issue
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        VM TO @VM, SM TO @SM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BALANCE.MAINTENANCE

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*----

    APPL = 'AA.PRD.DES.BALANCE.MAINTENANCE'
    F.FLDS = 'BAL.PROP.NAME':@VM:'TOT.OS.PRP.AMT':@VM:'BILL.CNT':@VM:'AMT.ADJ.BILL':@VM:'TOT.AMT.ADJ'
    CALL MULTI.GET.LOC.REF(APPL,F.FLDS,POS.SS)

    Y.PS.PRP = POS.SS<1,1>
    Y.PS.TOT = POS.SS<1,2>
    Y.PS.CNT = POS.SS<1,3>
    Y.PS.ADJ = POS.SS<1,4>
    Y.PS.ADJ.AM = POS.SS<1,5>

    Y.PROP.LIST = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.PRP>
    Y.AMT.ADJ.PBIL = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.ADJ>
    Y.TOT.ADJ.AMT = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.ADJ.AM>

    Y.PROP.CNT = DCOUNT(Y.PROP.LIST,@SM) ; FLG = ''
    R.NEW(AA.BM.ADJ.PROP.AMT) = ''

RETURN

PROCESS:
*-------

    LOOP
    WHILE Y.PROP.CNT GT 0 DO
        FLG += 1
        Y.PRP = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.PRP,FLG>
        Y.ADJ.PER.BIL = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.ADJ,FLG>
        Y.TOT.ADJ.AMT = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.ADJ.AM,FLG>
        Y.PRPO.CNT = R.NEW(AA.BM.LOCAL.REF)<1,Y.PS.CNT,FLG>
        GOSUB PROCESS.EACH.PROP
        Y.PROP.CNT -= 1
    REPEAT

    GOSUB PGM.END

RETURN

PROCESS.EACH.PROP:
*-----------------
    BEGIN CASE
        CASE Y.ADJ.PER.BIL NE '' AND Y.TOT.ADJ.AMT NE ''
            ETEXT = 'EB-BOTH.AMTS.CANT.ENTER'
            AF = AA.BM.LOCAL.REF
            AV = Y.PS.ADJ.AM
            AS = FLG
            CALL STORE.END.ERROR
        CASE Y.ADJ.PER.BIL NE ''
            GOSUB ADJUST.BILL.EACH
        CASE Y.TOT.ADJ.AMT NE ''
            GOSUB ADJUST.BILL.TOT.AMT
        CASE 1

    END CASE

RETURN

ADJUST.BILL.EACH:
*----------------

    Y.BILL.IDS = R.NEW(AA.BM.BILL.REF)
    Y.BL.CNT = DCOUNT(Y.BILL.IDS,@VM) ; FLG.BL = ''

    LOOP
    WHILE Y.BL.CNT GT 0 DO
        FLG.BL += 1
        Y.PROP.BL = R.NEW(AA.BM.PROPERTY)<1,FLG.BL>
        Y.PROP.BL = CHANGE(Y.PROP.BL,@SM,@VM)
        LOCATE Y.PRP IN Y.PROP.BL<1,1> SETTING POS.LP THEN
            R.NEW(AA.BM.ADJ.PROP.AMT)<1,FLG.BL,POS.LP> = Y.ADJ.PER.BIL
        END
        Y.BL.CNT -= 1
    REPEAT

RETURN

ADJUST.BILL.TOT.AMT:
*-------------------
    Y.BILL.IDS = R.NEW(AA.BM.BILL.REF)
    Y.BL.CNT = DCOUNT(Y.BILL.IDS,@VM) ; FLG.BL = ''

    LOOP
    WHILE Y.TOT.ADJ.AMT GT 0 AND Y.BL.CNT GT 0 DO
        FLG.BL += 1
        Y.PROP.BL = R.NEW(AA.BM.PROPERTY)<1,FLG.BL>
        Y.PROP.BL = CHANGE(Y.PROP.BL,@SM,@VM)
        LOCATE Y.PRP IN Y.PROP.BL<1,1> SETTING POS.LP THEN
            Y.CH.AMT = R.NEW(AA.BM.OS.PROP.AMT)<1,FLG.BL,POS.LP>
            IF Y.TOT.ADJ.AMT GE ABS(R.NEW(AA.BM.OS.PROP.AMT)<1,FLG.BL,POS.LP>) THEN
                R.NEW(AA.BM.ADJ.PROP.AMT)<1,FLG.BL,POS.LP> = ABS(R.NEW(AA.BM.OS.PROP.AMT)<1,FLG.BL,POS.LP>)
                Y.TOT.ADJ.AMT = Y.TOT.ADJ.AMT - ABS(R.NEW(AA.BM.OS.PROP.AMT)<1,FLG.BL,POS.LP>)
            END ELSE
                R.NEW(AA.BM.ADJ.PROP.AMT)<1,FLG.BL,POS.LP> = Y.TOT.ADJ.AMT
                Y.TOT.ADJ.AMT = 0
            END
        END
        Y.BL.CNT -= 1
    REPEAT

RETURN

PGM.END:
*-------
END
