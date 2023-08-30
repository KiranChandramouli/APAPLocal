* @ValidationCode : MjoxMTY3ODgzODY0OkNwMTI1MjoxNjgxMjk5NzI3MTA2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:12:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REINV.SYNC.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.REINV.SYNC.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 15-06-2010      SUJITHA.S   ODR-2009-10-0332  INITIAL CREATION
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.REINV.SYNC.COMMON

    FN.AZACCOUNT='F.AZ.ACCOUNT'
    F.AZACCOUNT=''
    CALL OPF(FN.AZACCOUNT,F.AZACCOUNT)

    FN.AZPRODUCT='F.AZ.PRODUCT.PARAMETER'
    F.AZPRODUCT=''
    CALL OPF(FN.AZPRODUCT,F.AZPRODUCT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCAP='F.ACCT.CAPITALISATION'
    F.ACCAP=''
    CALL OPF(FN.ACCAP,F.ACCAP)

    FN.AZ.SCHEDULES = 'F.AZ.SCHEDULES'
    F.AZ.SCHEDULES = ''
    CALL OPF(FN.AZ.SCHEDULES,F.AZ.SCHEDULES)

    FN.ACI='F.ACCOUNT.CREDIT.INT'
    F.ACI=''
    CALL OPF(FN.ACI,F.ACI)

    LOC.REF.APPL='AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER':@FM:'ACCOUNT'
    LOC.REF.FLD='L.AZ.IN.TRANSIT':@VM:'L.AZ.METHOD.PAY':@VM:'L.TYPE.INT.PAY':@FM:'L.AZP.TRAN.DAYS':@FM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.NOTIFY.2'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FLD,LOC.REF.POS)
    Y.INTRANSIT.POS=LOC.REF.POS<1,1>
    Y.AZ.METHOD.PAY.POS=LOC.REF.POS<1,2>
    Y.TYPE.INT.PAY.POS = LOC.REF.POS<1,3>
    Y.TRANSITDAYS.POS=LOC.REF.POS<2,1>
    Y.STATUS1.POS=LOC.REF.POS<3,1>
    Y.STATUS2.POS=LOC.REF.POS<3,2>
    Y.NOTIFY1.POS=LOC.REF.POS<3,3>
    Y.NOTIFY2.POS=LOC.REF.POS<3,4>

RETURN

END
