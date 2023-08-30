* @ValidationCode : MjoxOTU0OTc0ODA4OkNwMTI1MjoxNjgwNzc2MjA1MDgwOm11dGh1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:46:45
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
SUBROUTINE REDO.AUTH.ACCT.UPD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.AUTH.ACCT.UPD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This validation routine is used to warn when the user does any
* change to the ACI table manually by triggering a Warning Message

* Linked with: ACI,REDO.CR.MAIN
* In parameter : None
* out parameter : None
***---------------------------------------------------------------
***--------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO        REFERENCE         DESCRIPTION
* 10.04.2012      GANESH R   PACS00190849     INITIAL CREATION
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 VM to @VM
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*---------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*--------------
INIT:
*---------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.APPLN = 'ACCOUNT'
    LOC.REF.POS = ''
    LOC.FIELDS = 'L.STAT.INT.RATE':@VM:'L.DATE.INT.UPD'
    CALL MULTI.GET.LOC.REF(LOC.APPLN,LOC.FIELDS,LOC.REF.POS)

    LOC.STAT.INT.RATE = LOC.REF.POS<1,1>
    LOC.DATE.IN.UPD   = LOC.REF.POS<1,2>

RETURN
*--------------
PROCESS:
*--------------
    Y.ACI.ID = ID.NEW
    Y.ACC.ID = FIELD(Y.ACI.ID,'-',1)
    Y.DATE   = FIELD(Y.ACI.ID,'-',2)
    INT.RATE = R.NEW(IC.ACI.CR.INT.RATE)
    CNT.INT.RATE = DCOUNT(INT.RATE,@VM)
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
*PACS00303905 - S
        IF (CNT.INT.RATE EQ '1') THEN
            R.ACCOUNT<AC.LOCAL.REF,LOC.STAT.INT.RATE> = INT.RATE
        END ELSE
            R.ACCOUNT<AC.LOCAL.REF,LOC.STAT.INT.RATE> = ''
        END
*PACS00303905 - E
        R.ACCOUNT<AC.LOCAL.REF,LOC.DATE.IN.UPD> = Y.DATE
        CALL F.WRITE(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT)
    END
RETURN
*----------------------
END
