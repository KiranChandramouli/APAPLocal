* @ValidationCode : Mjo1MDE5ODEyNDM6Q3AxMjUyOjE2OTE1NzY2MTM1NjE6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Aug 2023 15:53:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
    SUBROUTINE LAPAP.V.FT.SWBANK.RT
*------------------------------------------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE              DESCRIPTION
*2022-09-12       ROQUEZADA                                  CREATE
*09/08/2023       VIGNESHWARI   MANUAL R22 CODE CONVERSION  T24.BP,TAM.BP is removed in insertfile
*--------------------------------------------------------------------------------------------------------
*
    $INSERT  I_EQUATE ;*MANUAL R22 CODE CONVERSION -T24.BP is removed in insertfile -START
    $INSERT  I_COMMON
    $INSERT  I_F.FUNDS.TRANSFER ;*MANUAL R22 CODE CONVERSION-END
    $INSERT  I_F.REDO.ACH.PARTICIPANTS ;*MANUAL R22 CODE CONVERSION -TAM.BP is removed in insertfile

*By: J.Q. / Lnovas
*Desc: Get Swift Bank code for FT,UNICA versions
*
    GOSUB PRELIM.CHECK

    IF(Y.SHOULD.CONTINUE EQ 1) THEN
        GOSUB DO.INI
        GOSUB DO.PROCESS
    END
    RETURN
PRELIM.CHECK:
    Y.SHOULD.CONTINUE =0;

    IF (PGM.VERSION EQ ',L.APAP.ACH.UNI') OR (PGM.VERSION EQ ',L.APAP.LBTR.UNI') THEN
        Y.SHOULD.CONTINUE = 1;
    END

    RETURN

DO.INI:
    FN.ACCOUNT  = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'FBNK.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACHPART = 'F.REDO.ACH.PARTICIPANTS'
    F.ACHPART = ''
    CALL OPF(FN.ACHPART,F.ACHPART)

    Y.APPL.NAME = "FUNDS.TRANSFER" : @FM : "CUSTOMER" : @FM : "REDO.ACH.PARTICIPANTS"
    Y.FLD.NAME = "L.ACH.PART.ID" : @VM : "L.TT.WV.TAX" : @VM : "L.TT.WV.TAX" : @VM :"L.FTST.ACH.PART" : @FM : "L.CU.CIDENT" : @FM : "L.LBTR.BIC"
    CALL MULTI.GET.LOC.REF(Y.APPL.NAME,Y.FLD.NAME,FLD.POS.ARR)
    Y.L.ACH.PART.ID.POS = FLD.POS.ARR<1,1>
    Y.L.TT.WV.TAX.POS = FLD.POS.ARR<1,2>
    Y.L.FTST.ACH.PART.POS = FLD.POS.ARR<1,4>
    Y.L.CU.CIDENT.POS = FLD.POS.ARR<2,1>
    Y.L.LBTR.BIC.POS = FLD.POS.ARR<3,1>

    RETURN

DO.PROCESS:
    ACH.PART.ID =  COMI
    IF ACH.PART.ID EQ '' THEN
        ACH.PART.ID = R.NEW(FT.LOCAL.REF)<1,Y.L.FTST.ACH.PART.POS>
    END

    CALL F.READ(FN.ACHPART,ACH.PART.ID,R.ACHPART,F.ACHPART,ACHPART.ERR)

    IF (R.ACHPART) THEN
        R.NEW(FT.ACCT.WITH.BANK) = 'SW.':R.ACHPART<REDO.ACH.PARTI.LOCAL.REF,Y.L.LBTR.BIC.POS,1>

    END
    RETURN

END

