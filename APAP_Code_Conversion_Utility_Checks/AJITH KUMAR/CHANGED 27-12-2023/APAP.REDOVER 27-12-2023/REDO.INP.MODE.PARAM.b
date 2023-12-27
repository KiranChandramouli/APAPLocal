* @ValidationCode : MjoxNzY5MDMxNDg3OkNwMTI1MjoxNzAzNjUxNDI4NDMzOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Dec 2023 10:00:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.MODE.PARAM
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* THIS ROUTINE IS A INPUT ROUTINE FOR THE VERSION OF ACCOUNT TO
* SHOW AN ERROR MESSAGE WHEN PAY MODE & INT.LIQ.ACC BOTH ARE NULL

* INPUT/OUTPUT:
*--------------
* IN : N/A
* OUT : N/A

* DEPENDDENCIES:
*-------------------------------------------------------------------------
* CALLED BY :
* CALLS :
* ------------------------------------------------------------------------
* Date who Reference Description
* 23-MAR-2010 SHANKAR RAJU ODR-2009-10-0795 Initial Creation
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T              R22 Manual Code Conversion        No Changes
* 27-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PAY.MODE.PARAM
    $INSERT I_F.ACCOUNT
    $USING EB.LocalReferences

    GOSUB INITIALSE
    GOSUB CHECK.PAY.MODE

RETURN
*----------------------------------------------------------------------
*~~~~~~~~~
INITIALSE:
*~~~~~~~~~

    FN.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
    F.PAY.MODE.PARAM = ''
    R.PAY.MODE.PARAM = ''
    CALL OPF(FN.PAY.MODE.PARAM,F.PAY.MODE.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    PMOD.POS = ''
* CALL GET.LOC.REF('ACCOUNT','L.AC.PAYMT.MODE',PMOD.POS)
    EB.LocalReferences.GetLocRef('ACCOUNT','L.AC.PAYMT.MODE',PMOD.POS);*R22 MANUAL CODE CONVERSION


RETURN
*----------------------------------------------------------------------
*~~~~~~~~~~~~~~~
CHECK.PAY.MODE:
*~~~~~~~~~~~~~~~

    Y.PAY.MODE = R.NEW(AC.LOCAL.REF)<1,PMOD.POS>
    Y.INT.LIQ.ACC = R.NEW(AC.INTEREST.LIQU.ACCT)
    IF (Y.PAY.MODE EQ '' OR Y.PAY.MODE EQ 'NONE') AND Y.INT.LIQ.ACC EQ '' THEN

*ERROR MSG : EITHER PAY.MODE OR INT.LIQ.ACCT SHOULD HAVE A VALUE
        AF = AC.LOCAL.REF
        AV = PMOD.POS
        ETEXT = 'EB-BOTH.NOT.NUL'
        CALL STORE.END.ERROR
    END

    IF Y.PAY.MODE AND Y.INT.LIQ.ACC EQ '' THEN
        AF = AC.INTEREST.LIQU.ACCT
        ETEXT = 'AC-MAND.FLD'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------
END
