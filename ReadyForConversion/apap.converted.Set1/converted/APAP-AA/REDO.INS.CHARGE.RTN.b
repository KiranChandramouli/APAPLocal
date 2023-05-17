SUBROUTINE REDO.INS.CHARGE.RTN
*------------------------------------------------------------------------------------------------------------------
* Developer    : NAVEENKUMAR.N
* Date         : 31.05.2010
* Description  : REDO.INS.CHARGE.RTN will appends the value of local fields MON.POL.AMT or MON.TOT.PRE.AMT based
*                on the value  present in EXTRA.AMOUNT field
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_AA.LOCAL.COMMON
*
    GOSUB PROCESS
RETURN
*******
PROCESS:
*******
    GOSUB MULTI.GET.LOC.REF

    EXTRA.AMT = R.Condition.charge<AA.CHG.LOCAL.REF><1,EXTRA.AMT.POS>
    IF EXTRA.AMT NE "" THEN
        MON.POL.AMT = R.Condition.charge<AA.CHG.LOCAL.REF><1,MON.POL.AMT.POS>
        R.Condition.charge<AA.CHG.CHG.AMOUNT>= MON.POL.AMT
    END ELSE
        MON.POL.PRE.AMT = R.Condition.charge<AA.CHG.LOCAL.REF><1,MON.TOT.PRE.AMT.POS>
        R.Condition.charge<AA.CHG.CHG.AMOUNT> = MON.POL.PRE.AMT
    END
RETURN
******************
MULTI.GET.LOC.REF:
******************
    APPLICATION = "AA.PRD.DES.CHARGE"
    FIELD.NAME = "MON.POL.AMT":@VM:"EXTRA.AMT":@VM:"MON.TOT.PRE.AMT"
    FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(APPLICATION,FIELD.NAME,FIELD.POS)
*
    MON.POL.AMT.POS = FIELD.POS<1,1>
    EXTRA.AMT.POS = FIELD.POS<1,2>
    MON.TOT.PRE.AMT.POS = FIELD.POS<1,3>
RETURN
END
