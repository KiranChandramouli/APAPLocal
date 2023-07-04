* @ValidationCode : Mjo2MDU1OTUxOTg6Q3AxMjUyOjE2ODA2ODEyODA3Mjc6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:24:40
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
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.LOAN.DSN.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

    DEST.OF.FUNDS = ''
    R.AA.ARRANGEMENT = RCL$COMM.LOAN(1)
** Get SECTOR
** IF SEC.VAL EQ '03.01.99' THEN
    ArrangementID = COMI
    effectiveDate = ''
    idPropertyClass = 'ACCOUNT'
    idProperty = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.ARR.ACCOUNT = RAISE(returnConditions)
*    IF R.AA.ARR.ACCOUNT<1> EQ 'LENDING-TAKEOVER-ARRANGEMENT' OR R.AA.ARR.ACCOUNT<1> EQ 'LENDING-NEW-ARRANGEMENT' THEN
    DEST.OF.FUNDS = R.AA.ARR.ACCOUNT<AA.AC.LOCAL.REF,L.AA.LOAN.DSN.POS>
*    END
*END ELSE
*DEST.OF.FUNDS = ''
*END
*
    IF DEST.OF.FUNDS THEN
        COMI = DEST.OF.FUNDS
    END
*
RETURN
END
