* @ValidationCode : MjoxNjM0MzA2MTMzOkNwMTI1MjoxNjk4NDA1NTM5NjA5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-65</Rating>
*-----------------------------------------------------------------------------
*    SUBROUTINE ITSS.MF.USER.DETAILS(ACTION.INFO, RESERVED.1, RESERVED.2, RESERVED.3, RESERVED.4, MOB.RESPONSE, MOB.ERROR)
    SUBROUTINE ITSS.MF.USER.DETAILS(ACTION.INFO, REQUEST, MOB.RESPONSE, MOB.ERROR)
        

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI       MANUAL R23 CODE CONVERSION                VM TO @VM,SM TO @SM,FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
* Description :
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.EXTERNAL.USER
	$INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_EB.MOB.FRMWRK.COMMON
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS.EXT.USER

    RETURN


*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    MOB.RESPONSE = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

	FN.CUSTOMER = 'F.CUSTOMER'
	F.CUSTOMER = ''
	CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    MOB.RESPONSE<1, 1> = 'ACCOUNT.NUMBER':@SM:'SHORT.TITLE'

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.EXT.USER:
*----------------

*    R.EXT.USER = ''
*    E.EXT.USER = ''
*    CALL F.READ(FN.EB.EXTERNAL.USER, EXT.USER.ID, R.EXT.USER, F.EB.EXTERNAL.USER, E.EXT.USER)
*    IF NOT(E.EXT.USER) THEN
*        EXT.USER.NAME = R.EXT.USER<EB.XU.NAME>
*        CUSTOMER.CODE = R.EXT.USER<EB.XU.CUSTOMER>
*        GOSUB PROCESS.CUS.ACC
*        MOB.RESPONSE<1, 1> = EXT.USER.NAME
*        LAST.DATE = R.EXT.USER<EB.XU.DATE.LAST.USE, 1>
*        LAST.SIGN.ON.DATE = LAST.DATE[7,2]:'/':LAST.DATE[5,2]:'/':LAST.DATE[3,2]
*        LAST.TIME = R.EXT.USER<EB.XU.TIME.LAST.USE, 1>
*        LAST.SIGN.ON.TIME = LAST.TIME[1,2]:':':LAST.TIME[3,2]
*        MOB.RESPONSE<1, 2> = LAST.SIGN.ON.DATE:' ':LAST.SIGN.ON.TIME
*    END ELSE
*        MOB.ERROR = 'INVALID USER ID - ':EXT.USER.ID
*    END

    CUSTOMER.CODE = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>

    GOSUB PROCESS.CUS.ACC

	CALL F.READ(FN.CUSTOMER, CUSTOMER.CODE, R.CUSTOMER, F.CUSTOMER, E.CUS)
	
*    I = NB.ACC + 1
	IF NOT(E.CUS) THEN
		SAVE.CUSTOMER.CODE = CUSTOMER.CODE
		CUS.REL.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
		CUS.REL.CUS = R.CUSTOMER<EB.CUS.REL.CUSTOMER>
		REL.CUS.CNT = DCOUNT(CUS.REL.CODE, @VM)
		FOR CUS.CNT = 1 TO REL.CUS.CNT
			IF CUS.REL.CODE<1, CUS.CNT> EQ 17 THEN
				CUSTOMER.CODE = CUS.REL.CUS<1, CUS.CNT>
				GOSUB PROCESS.CUS.ACC
			END
		NEXT CUS.CNT
	END

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.CUS.ACC:
*---------------

    E.CUS.ACC = ''
    R.CUS.ACC = ''
    NB.ACC = 0
    ACCT.NO = ''

    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.CODE,R.CUS.ACC,F.CUSTOMER.ACCOUNT,E.CUS.ACC)

    IF NOT(E.CUS.ACC) THEN
        NB.ACC = DCOUNT(R.CUS.ACC, @FM)
        FOR I = 1 TO NB.ACC
            ACCT.NO = R.CUS.ACC<I>
            IF ACCT.NO THEN
                GOSUB PROCESS.ACC
            END
        NEXT I
    END

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.ACC:
*-----------

    E.ACC = ''
    R.ACC = ''

    CALL F.READ(FN.ACCOUNT,ACCT.NO,R.ACC,F.ACCOUNT,E.ACC)
    IF NOT(E.ACC) THEN
        ACCOUNT.NUMBER = ACCT.NO
        SHORT.TITLE = R.ACC<AC.SHORT.TITLE>
    END

    MOB.RESPONSE<1, -1> = ACCOUNT.NUMBER:@SM:SHORT.TITLE

    RETURN

*---------------------------------------------------------------------------------------------------
END
