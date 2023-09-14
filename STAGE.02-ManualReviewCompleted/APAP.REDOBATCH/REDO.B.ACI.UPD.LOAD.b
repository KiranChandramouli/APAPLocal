* @ValidationCode : MjoxNjY4ODI4NDc6Q3AxMjUyOjE2ODA3ODA1MzkxNzg6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:58:59
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
SUBROUTINE REDO.B.ACI.UPD.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.ACI.UPD.LOAD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.ACI.UPD.LOAD

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION VM TO @VM
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.DATES
    $INSERT I_F.REDO.UPD.ACC.LIST
    $INSERT I_F.REDO.ACC.CR.INT
    $INSERT I_REDO.B.ACI.UPD.COMMON

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CREDIT.INT='F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT=''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.REDO.ACC.CR.INT='F.REDO.ACC.CR.INT'
    F.REDO.ACC.CR.INT=''
    CALL OPF(FN.REDO.ACC.CR.INT,F.REDO.ACC.CR.INT)

    FN.BASIC.INTEREST='F.BASIC.INTEREST'
    F.BASIC.INTEREST=''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.REDO.UPD.ACC.LIST='F.REDO.UPD.ACC.LIST'
    F.REDO.UPD.ACC.LIST=''
    CALL OPF(FN.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST)

    LREF.APP='ACCOUNT'
    LREF.FIELD='L.AC.STATUS1':@VM:'L.STAT.INT.RATE':@VM:'L.DATE.INT.UPD':@VM:'L.AC.MAN.UPD'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.L.AC.STATUS1=LREF.POS<1,1>
    POS.L.STAT.INT.RATE=LREF.POS<1,2>
    POS.L.DATE.INT.UPD=LREF.POS<1,3>
    POS.L.AC.MAN.UPD=LREF.POS<1,4>

RETURN
END
