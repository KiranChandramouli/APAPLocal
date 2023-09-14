* @ValidationCode : MjotMTU5NjE0MTg3MTpDcDEyNTI6MTY4MDc3NzIxMTQ4MjptdXRodTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:03:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.LOAN.ACC.CLOSE
*-----------------------------------------------
*Description: This is the Auth routine for the account closure
* of the Loan account to update the REDO.CUST.PRD.LIST
*-----------------------------------------------
* Input  Arg : N/A
* Output Arg : N/A
* Deals With : Account Closure
*-----------------------------------------------
*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.CUST.PRD.LIST


    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------
INIT:
*-----------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    FN.REDO.CUST.PRD.LIST = 'F.REDO.CUST.PRD.LIST'
    F.REDO.CUST.PRD.LIST = ''
    CALL OPF(FN.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*-----------------------------------------------
PROCESS:
*-----------------------------------------------
    Y.ACC.NO = ID.NEW
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT ELSE
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ACC.NO,R.ACCOUNT,ACC.ERR)
    END

    IF R.ACCOUNT ELSE
        RETURN
    END

    Y.CUS.ID = R.ACCOUNT<AC.CUSTOMER>
    Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.REDO.CUST.PRD.LIST,Y.CUS.ID,R.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST,CUST.PRD.ERR)
    IF R.REDO.CUST.PRD.LIST THEN
        LOCATE ID.NEW IN R.REDO.CUST.PRD.LIST<PRD.PRODUCT.ID,1> SETTING POS1 THEN
            R.REDO.CUST.PRD.LIST<PRD.PRD.STATUS,POS1> = 'CLOSED'
            R.REDO.CUST.PRD.LIST<PRD.DATE,POS1> = TODAY
            R.REDO.CUST.PRD.LIST<PRD.PROCESS.DATE> = TODAY
            CALL F.WRITE(FN.REDO.CUST.PRD.LIST,Y.CUS.ID,R.REDO.CUST.PRD.LIST)

        END
    END

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)

    IF R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS> EQ 'CURRENT' THEN
        R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS> = 'EXPIRED'
        CALL F.WRITE(FN.AA.ARRANGEMENT,Y.ARR.ID,R.AA.ARRANGEMENT)
    END
RETURN
END
