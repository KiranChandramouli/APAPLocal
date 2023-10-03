* @ValidationCode : MjotMzIyMjc0MjcyOkNwMTI1MjoxNjg4NDY0ODgxMzQwOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jul 2023 15:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP


*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------

*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*04-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.CH.ABONO.CUS.CODE
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT ;*R22 MANUAL CONVERSION END

    Y.ACC.ID         = O.DATA

    FN.CUSTOMER = 'F.CUSTOMER';
    F.CUSTOMER = '';
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT';
    F.ACCOUNT = '';
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT';
    F.AA.ARRANGEMENT = '';
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    R.ACC = ''; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
    Y.ARRANGEMENT.ID         = R.ACC<AC.ARRANGEMENT.ID>

    R.ARRANGEMENT = ''; ARRANGEMENT.ERR = ''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGEMENT.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARRANGEMENT.ERR)
    Y.CUST.ID         = R.ARRANGEMENT<AA.ARR.CUSTOMER>

    O.DATA            = Y.CUST.ID
RETURN
END
