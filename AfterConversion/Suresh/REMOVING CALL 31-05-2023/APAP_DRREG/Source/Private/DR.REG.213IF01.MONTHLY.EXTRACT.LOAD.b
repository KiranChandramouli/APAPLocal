* @ValidationCode : MjotMTcwNTUwMzU5OTpDcDEyNTI6MTY4NDg1Njg2OTg3OTpJVFNTOi0xOi0xOjg3NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 874
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF01.MONTHLY.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.MONTHLY.EXTRACT
* Date           : 2-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the tranactions made over 10000 by individual Customer daily.
*-----------------------------------------------------------------------------
*
* MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION       NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES

    $INSERT I_DR.REG.213IF01.MONTHLY.EXTRACT.COMMON
    $INSERT I_F.DR.REG.213IF01.PARAM

    GOSUB OPEN.FILES
    GOSUB INIT.PARA

RETURN
*----------------------------------------------------------
OPEN.FILES:
***********

    FN.CUSTOMER = 'F.CUSTOMER'  ; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'  ; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'  ; F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY, F.STMT.ENTRY)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'  ; F.FT.HIS = ''
    CALL OPF(FN.FT.HIS, F.FT.HIS)

    FN.TT.HIS = 'F.TELLER$HIS'  ; F.TT.HIS = ''
    CALL OPF(FN.TT.HIS, F.TT.HIS)

    FN.ACCT.ENT.LWORK.DAY = 'F.ACCT.ENT.LWORK.DAY'  ; F.ACCT.ENT.LWORK.DAY = ""
    CALL OPF(FN.ACCT.ENT.LWORK.DAY, F.ACCT.ENT.LWORK.DAY)

    FN.DR.REG.213IF01.PARAM = 'F.DR.REG.213IF01.PARAM'   ; F.DR.REG.213IF01.PARAM = ''
    CALL OPF(FN.DR.REG.213IF01.PARAM, F.DR.REG.213IF01.PARAM)

    FN.DR.REG.213IF01.CONCAT = 'F.DR.REG.213IF01.CONCAT'
    CALL OPF(FN.DR.REG.213IF01.CONCAT,F.DR.REG.213IF01.CONCAT)

    FN.DR.REG.213IF01.WORKFILE = 'F.DR.REG.213IF01.WORKFILE'
    F.DR.REG.213IF01.WORKFILE = ''
    CALL OPF(FN.DR.REG.213IF01.WORKFILE,F.DR.REG.213IF01.WORKFILE)

RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********

*  CALL F.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, F.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)        ;*/ TUS START/END
    CALL CACHE.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)
    LAST.WRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)

    LOC.APP = "FUNDS.TRANSFER":@FM:"TELLER":@FM:"CUSTOMER":@FM:'ACCOUNT'
    FT.FLDS = "L.RTE.FORM":@VM:"L.LAST.NAME":@VM:"L.2ND.LAST.NAME":@VM:"L.1ST.NAME":@VM:"L.2ND.NAME":@VM:"L.NEW.ID.CARD":@VM:"L.OLD.ID.CARD":@VM:"L.PASSPORT":@VM:"L.ACT.INT":@VM:"L.PEP.INTERM":@VM:"L.TYPE.PEP.INT":@VM:"L.PAIS":@VM:"L.ID.PERS.BENEF":@VM:"L.FT.CLNT.TYPE":@VM:"L.NATIONALITY":@VM:"L.SEX":@VM:"BENEFIC.NAME" ;*R22 AUTO CODE CONVERSION
    TT.FLDS = "L.RTE.FORM":@VM:"L.LAST.NAME":@VM:"L.2ND.LAST.NAME":@VM:"L.1ST.NAME":@VM:"L.2ND.NAME":@VM:"L.NEW.ID.CARD":@VM:"L.OLD.ID.CARD":@VM:"L.PASSPORT":@VM:"L.TT.FXSN.NUM":@VM:"L.ACT.INT":@VM:"L.PEP.INTERM":@VM:"L.TYPE.PEP.INT":@VM:"L.PAIS":@VM:"L.ID.PERS.BENEF":@VM:"L.FT.CLNT.TYPE":@VM:"L.NATIONALITY":@VM:"L.SEX":@VM:"BENEFICIARY.NAM" ;*R22 AUTO CODE CONVERSION
    CUS.FLDS = "L.CU.TIPO.CL":@VM:"L.CU.RNC":@VM:"L.CU.CIDENT":@VM:"L.CU.PEPS":@VM:"L.CUS.PEP":@VM:"L.APAP.INDUSTRY"   ;*R22 AUTO CODE CONVERSION
    AC.FLDS = "L.AC.STATUS1":@VM:"L.AC.STATUS2" ;*R22 AUTO CODE CONVERSION
    LOC.FLD = FT.FLDS:@FM:TT.FLDS:@FM:CUS.FLDS:@FM:AC.FLDS ;*R22 AUTO CODE CONVERSION
    LOC.POS = ""
*
    CALL MULTI.GET.LOC.REF(LOC.APP, LOC.FLD, LOC.POS)
    FT.L.RTE.FORM.POS = LOC.POS<1,1>
    FT.LAST.NAME.POS = LOC.POS<1,2>
    FT.2ND.LAST.POS = LOC.POS<1,3>
    FT.L.1ST.NAME.POS = LOC.POS<1,4>
    FT.L.2ND.NAME.POS = LOC.POS<1,5>
    FT.L.NEW.ID.CARD.POS = LOC.POS<1,6>
    FT.L.OLD.ID.CARD.POS = LOC.POS<1,7>
    FT.L.PASSPORT.POS = LOC.POS<1,8>
    FT.L.ACT.INT.POS = LOC.POS<1,9>
    FT.L.PEP.INTERM.POS = LOC.POS<1,10>
    FT.L.TYPE.PEP.INT.POS = LOC.POS<1,11>
    FT.L.PAIS.POS = LOC.POS<1,12>
    FT.L.ID.PERS.BENEF.POS = LOC.POS<1,13>
    FT.L.FT.CLNT.TYPE.POS = LOC.POS<1,14>
    FT.L.NATIONALITY.POS = LOC.POS<1,15>
    FT.L.SEX.POS = LOC.POS<1,16>
    FT.BEN.NAME.POS = LOC.POS<1,17>
    TT.L.RTE.FORM.POS = LOC.POS<2,1>
    TT.LAST.NAME.POS = LOC.POS<2,2>
    TT.2ND.LAST.POS = LOC.POS<2,3>
    TT.L.1ST.NAME.POS = LOC.POS<2,4>
    TT.L.2ND.NAME.POS = LOC.POS<2,5>
    TT.L.NEW.ID.CARD.POS = LOC.POS<2,6>
    TT.L.OLD.ID.CARD.POS = LOC.POS<2,7>
    TT.L.PASSPORT.POS = LOC.POS<2,8>
    L.TT.FXSN.NUM.POS = LOC.POS<2,9>
    TT.L.ACT.INT.POS = LOC.POS<2,10>
    TT.L.PEP.INTERM.POS = LOC.POS<2,11>
    TT.L.TYPE.PEP.INT.POS = LOC.POS<2,12>
    TT.L.PAIS.POS = LOC.POS<2,13>
    TT.L.ID.PERS.BENEF.POS = LOC.POS<2,14>
    TT.L.FT.CLNT.TYPE.POS = LOC.POS<2,15>
    TT.L.NATIONALITY.POS = LOC.POS<2,16>
    TT.L.SEX.POS = LOC.POS<2,17>
    TT.BEN.NAME.POS = LOC.POS<2,18>
*
    TIPO.CL.POS = LOC.POS<3,1>
    CIDENT.POS = LOC.POS<3,3>
    RNC.POS = LOC.POS<3,2>
    L.CU.PEPS.POS = LOC.POS<3,4>
    L.CUS.PEP.POS = LOC.POS<3,5>
    Y.APAP.INDUS.POS = LOC.POS<3,6>
*
    AC.STATUS1.POS = LOC.POS<4,1>
    AC.STATUS2.POS = LOC.POS<4,2>
*
RETURN
*----------------------------------------------------------------
END
