* @ValidationCode : Mjo2NDQ0Mzk5NDI6Q3AxMjUyOjE2ODg0NjQ4ODE1MTU6dmljdG86LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE LAPAP.CH.ABONO.USR.INPU
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER ;*R22 MANUAL CONVERSION END

    Y.USR.INP         = O.DATA
    Y.USER.ID         = FIELD(Y.USR.INP,'_',2)

    FN.USER = 'F.USER';
    F.USER = '';
    CALL OPF(FN.USER, F.USER)

    R.USER.LIST = ''; USER.LIST.ERR = ''
    CALL F.READ(FN.USER,Y.USER.ID,R.USER.LIST,F.USER,USER.LIST.ERR)
    Y.USER.NAME         = R.USER.LIST<EB.USE.USER.NAME>

    O.DATA                = Y.USER.NAME
RETURN
END
