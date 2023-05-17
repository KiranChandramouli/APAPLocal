SUBROUTINE REDO.V.VAL.ACCOUNT.INITIAL
*------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry NOFILE.REDO.INS.PAYMENTS
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : REDO.V.VAL.ACCOUNT.INITIAL
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
* 24.06.2010 HARISH.Y ODR-2009-10-0340 INITIAL CREATION
* -----------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------
INIT:
*---------
    CALL GET.LOC.REF('AA.ARR.ACCOUNT',POLICY.STATUS,POL.STAT.POS)
RETURN

*----------
PROCESS:
*----------

    R.NEW(AA.AC.LOCAL.REF)<1,POL.STAT.POS> = 'CURRENT'
RETURN
END
