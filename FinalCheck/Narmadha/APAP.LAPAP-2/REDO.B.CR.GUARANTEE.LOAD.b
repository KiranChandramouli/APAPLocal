* @ValidationCode : Mjo2NDMzNzE4MDpDcDEyNTI6MTY4MjMzMTU2NzE0MzpJVFNTOi0xOi0xOjI0NDI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2442
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.CR.GUARANTEE.LOAD
*--------------------------------------------------------------------------------------------------
* Description           : This is the Batch Load Routine used to initalize all the required variables
*
* Developed By          : Vijayarani G
*
* Development Reference : 786711(FS-200-DE03)
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* PACS00353058          Ashokkumar.V.P                  11/11/2014           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  26/05/2015           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  02/06/2015           Changes the fields based on new mapping
* CI008098              Ashokkumar.V.P                  04/01/2018           Ajustar el descripción de la garantía de créditos Hipotecarios

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP, SM TO @SM
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON                                     ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_TSA.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.CR.GUARANTEE.COMMON
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.EB.LOOKUP                                 ;** R22 Auto conversion - END
*
    GOSUB INITIALISATION
    GOSUB GET.BATCH.VALUE
    GOSUB MULTI.LOC.REF
*
RETURN
*
*--------------
INITIALISATION:
*-------------
*
    L.COL.SEC.IDEN.POS = "";     L.COL.SEC.DESC.POS = "";     L.COL.EXE.DATE.POS = "";     L.COL.GT.DATE.POS = ""
    L.COL.VAL.DATE.POS = "";     L.COL.TOT.VALUA.POS = "";     L.ECN.NUMBER.POS = "";     L.COL.INVST.TYE.POS = ""
    L.COL.NAT.TAX.POS = "";     L.COL.INS.PLCY.POS = "";     L.COL.POL.DATE.POS = "";     L.COL.GUAR.TYPE.POS = ""
    L.CO.LOAN.AMT.POS = "";     L.COL.YR.BLDING.POS = "";     L.CU.TIPO.CL.POS = "";     L.CU.CIDENT.POS = ""
    L.CU.RNC.POS = "";     L.CU.FOREIGN.POS = "";     L.CU.DEBTOR.POS = "";     L.AA.COL.POS = "";     L.AA.CATEG.POS = ""
    FN.AA.ARRANGEMENT = "";     F.AA.ARRANGEMENT = "";     FN.COLLATERAL = "";     F.COLLATERAL = "";     FN.CUSTOMER = ""
    F.CUSTOMER = "";     FN.AA.PRD.DES.TERM.AMOUNT = "";     F.AA.PRD.DES.TERM.AMOUNT = "";     FN.REDO.H.REPORTS.PARAM = ""
    F.REDO.H.REPORTS.PARAM = "";     FN.INDUSTRY = "";    F.INDUSTRY = "";     FN.AA.ARRANGEMENT = "";     F.AA.ARRANGEMENT = ""
    FN.COLLATERAL = "";     F.COLLATERAL = "";     Y.REPORT.PARAM.ID = "";     Y.RCL.ID = "";     Y.FILE.NAME = ""
    Y.FIELD.NME.ARR = "";     Y.FIELD.VAL.ARR = "";     Y.DISP.TEXT.ARR = "";     Y.FILE.NAME = "";     Y.APPLN = ""
    Y.FLD = "";     L.APAP.INDUSTRY.POS = '';     L.COL.GUR.LEGID.POS = ''; L.COL.GUAR.ID.POS = ''; L.COL.GUAR.NAME.POS = ''
    Y.L.CR.FACILITY.POS = ''; L.COL.INVST.NO.POS = ''; L.COL.NUM.INSTR.POS = '' ; L.COL.ENTY.INS.POS = '' ; L.COL.DEBTOR.NA.POS = ''


*
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
    FN.COLLATERAL = "F.COLLATERAL"
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
*
    FN.CUSTOMER = "F.CUSTOMER"
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.AA.PRD.DES.TERM.AMOUNT = "F.AA.PRD.DES.TERM.AMOUNT"
    CALL OPF(FN.AA.PRD.DES.TERM.AMOUNT,F.AA.PRD.DES.TERM.AMOUNT)
*
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
*
    FN.INDUSTRY = "F.INDUSTRY"
    CALL OPF(FN.INDUSTRY,F.INDUSTRY)

    FN.COLLATERAL.TYPE = 'F.COLLATERAL.TYPE'
    F.COLLATERAL.TYPE = ''
    CALL OPF(FN.COLLATERAL.TYPE,F.COLLATERAL.TYPE)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.DR.REG.DE03.WORKFILE = 'F.DR.REG.DE03.WORKFILE'; F.DR.REG.DE03.WORKFILE =''
    CALL OPF(FN.DR.REG.DE03.WORKFILE,F.DR.REG.DE03.WORKFILE)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'; F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.APAP.H.INSURANCE.ID.CONCAT = 'F.APAP.H.INSURANCE.ID.CONCAT'; F.APAP.H.INSURANCE.ID.CONCAT = ''
    CALL OPF(FN.APAP.H.INSURANCE.ID.CONCAT,F.APAP.H.INSURANCE.ID.CONCAT)

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS';    F.APAP.H.INSURANCE.DETAILS = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.AA.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.TERM.AMOUNT = ''
    CALL OPF(FN.AA.TERM.AMOUNT,F.AA.TERM.AMOUNT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)

    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'; F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

    FN.EB.LOOKUP = "F.EB.LOOKUP"; F.EB.LOOKUP  = ""
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.POLIZA = "F.ST.L.APAP.POLIZA.SEGURO.RNC" ; FV.POLIZA = ""
    CALL OPF(FN.POLIZA,FV.POLIZA)

    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YL.TODAY = TODAY
    CALL CDT('',YL.TODAY,'-1C')
    IF LAST.WORK.DAY[5,2] NE YL.TODAY[5,2] THEN
        COMI = LAST.WORK.DAY[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        YL.TODAY = COMI
    END
RETURN
*
*---------------
GET.BATCH.VALUE:
*---------------
*
    Y.TODATE   = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.REPORT.PARAM.ID = "REDO.DE03"
    Y.RCL.ID          = "REDO.RCL.DE03"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END

    LOCATE "COLLATERAL.CODE" IN Y.FIELD.NME.ARR<1,1> SETTING COD.POS THEN
        Y.COLL.VAL.ARR = Y.FIELD.VAL.ARR<1,COD.POS>
        Y.COLL.DIS.ARR = Y.DISP.TEXT.ARR<1,COD.POS>
        Y.COLL.VAL.ARR = CHANGE(Y.COLL.VAL.ARR,@SM,@VM)
        Y.COLL.DIS.ARR = CHANGE(Y.COLL.DIS.ARR,@SM,@VM)
    END

    LOCATE "VALUATION.DTE.FLD" IN Y.FIELD.NME.ARR<1,1> SETTING VALD.POS THEN
        Y.VALUDTE.VAL.ARR = Y.FIELD.VAL.ARR<1,VALD.POS>
        Y.VALUDTE.VAL.ARR = CHANGE(Y.VALUDTE.VAL.ARR,@SM,@VM)
    END

    LOCATE "VALUATION.AMT.FLD" IN Y.FIELD.NME.ARR<1,1> SETTING VALA.POS THEN
        Y.VALUAMT.VAL.ARR = Y.FIELD.VAL.ARR<1,VALA.POS>
        Y.VALUAMT.VAL.ARR = CHANGE(Y.VALUAMT.VAL.ARR,@SM,@VM)
    END

    LOCATE "TIT.COLL.TYPE.12" IN Y.FIELD.NME.ARR<1,1> SETTING COL.POS THEN
        Y.COLLTYP.VAL.ARR = Y.FIELD.VAL.ARR<1,VALA.POS>
        Y.COLLTYP.VAL.ARR = CHANGE(Y.COLLTYP.VAL.ARR,@SM,@VM)
    END

    LOCATE "ISSUER.ID.13" IN Y.FIELD.NME.ARR<1,1> SETTING ISSID.POS THEN
        Y.ISSID.VAL.ARR = Y.FIELD.VAL.ARR<1,ISSID.POS>
        Y.ISSID.VAL.ARR = CHANGE(Y.ISSID.VAL.ARR,@SM,@VM)
    END
    LOCATE "AA.PROD.LC" IN Y.FIELD.NME.ARR<1,1> SETTING PRDSB.POS THEN
        Y.PRDSB.VAL.ARR = Y.FIELD.VAL.ARR<1,PRDSB.POS>
        Y.PRDSB.DIS.ARR = Y.DISP.TEXT.ARR<1,PRDSB.POS>
        Y.PRDSB.VAL.ARR = CHANGE(Y.PRDSB.VAL.ARR,@SM,@VM)
        Y.PRDSB.DIS.ARR = CHANGE(Y.PRDSB.DIS.ARR,@SM,@VM)
    END
    LOCATE "FETCHA.7.8" IN Y.FIELD.NME.ARR<1,1> SETTING FET78.POS THEN
        Y.FETCH.VAL.ARR = Y.FIELD.VAL.ARR<1,FET78.POS>
        Y.FETCH.VAL.ARR = CHANGE(Y.FETCH.VAL.ARR,@SM,@VM)
    END

    LOCATE "INSUR.POLCY" IN Y.FIELD.NME.ARR<1,1> SETTING INSP.POS THEN
        Y.INSP.VAL.ARR = Y.FIELD.VAL.ARR<1,INSP.POS>
        Y.INSP.VAL.ARR = CHANGE(Y.INSP.VAL.ARR,@SM,@VM)
    END
RETURN
*
*------------
MULTI.LOC.REF:
*------------
    Y.APPLN = "COLLATERAL":@FM:"CUSTOMER":@FM:"AA.ARR.TERM.AMOUNT":@FM:"INDUSTRY":@FM:'AA.PRD.DES.OVERDUE':@FM:"AA.PRD.DES.ACCOUNT"
    Y.FLD = "L.COL.SEC.IDEN":@VM:"L.COL.SEC.DESC":@VM:"L.COL.EXE.DATE":@VM:"L.COL.GT.DATE":@VM:"L.COL.VAL.DATE":@VM:"L.COL.TOT.VALUA":@VM:"L.ECN.NUMBER":@VM:"L.COL.INVST.TYE"
    Y.FLD := @VM:"L.COL.NAT.TAX":@VM:"L.COL.INS.PLCY":@VM:"L.COL.POL.DATE":@VM:"L.COL.GUAR.TYPE":@VM:"L.CO.LOAN.AMT":@VM:"L.COL.YR.BLDING":@VM:"L.COL.PRO.DESC2":@VM:"L.COL.GUR.LEGID":@VM:"L.COL.GUAR.ID":@VM:"L.COL.GUAR.NAME":@VM:"L.AC.LK.COL.ID"
    Y.FLD := @VM:"L.APAP.GRTA.FID":@VM:"L.APAP.CLA.FIDE":@VM:"L.APAP.DES.FIDE":@VM:"L.COL.VALU.NAM":@VM:"L.COL.INVST.NO":@VM:"L.COL.NUM.INSTR":@VM:"L.COL.ENTY.INS":@VM:"L.COL.DEBTOR.NA"
    Y.FLD := @FM:"L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC"
    Y.FLD := @VM:"L.CU.PASS.NAT":@VM:"L.CU.DEBTOR":@VM:"L.APAP.INDUSTRY":@VM:"L.AA.MMD.PYME":@FM:"L.AA.COL":@VM:"L.AA.COL.VAL":@FM:"L.AA.CATEG":@FM:'L.LOAN.STATUS.1'
    Y.FLD := @FM:"L.CR.FACILITY"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.FLD,Y.POS)
    L.COL.SEC.IDEN.POS  = Y.POS<1,1>
    L.COL.SEC.DESC.POS  = Y.POS<1,2>
    L.COL.EXE.DATE.POS  = Y.POS<1,3>
    L.COL.GT.DATE.POS   = Y.POS<1,4>
    L.COL.VAL.DATE.POS  = Y.POS<1,5>
    L.COL.TOT.VALUA.POS = Y.POS<1,6>
    L.ECN.NUMBER.POS    = Y.POS<1,7>
    L.COL.INVST.TYE.POS = Y.POS<1,8>
    L.COL.NAT.TAX.POS   = Y.POS<1,9>
    L.COL.INS.PLCY.POS  = Y.POS<1,10>
    L.COL.POL.DATE.POS  = Y.POS<1,11>
    L.COL.GUAR.TYPE.POS = Y.POS<1,12>
    L.CO.LOAN.AMT.POS   = Y.POS<1,13>
    L.COL.YR.BLDING.POS = Y.POS<1,14>
    L.COL.PRO.DESC2.POS = Y.POS<1,15>
    L.COL.GUR.LEGID.POS = Y.POS<1,16>
    L.COL.GUAR.ID.POS = Y.POS<1,17>
    L.COL.GUAR.NAME.POS = Y.POS<1,18>
    L.AC.LK.COL.ID.POS = Y.POS<1,19>
    Y.GRTA.FID.POS = Y.POS<1,20>
    Y.CLA.FIDE.POS = Y.POS<1,21>
    Y.DES.FIDE.POS = Y.POS<1,22>
    Y.VALU.NAM.POS = Y.POS<1,23>
    L.COL.INVST.NO.POS = Y.POS<1,24>
    L.COL.NUM.INSTR.POS = Y.POS<1,25>
    L.COL.ENTY.INS.POS = Y.POS<1,26>
    L.COL.DEBTOR.NA.POS =Y.POS<1,27>
    L.CU.TIPO.CL.POS    = Y.POS<2,1>
    L.CU.CIDENT.POS     = Y.POS<2,2>
    L.CU.RNC.POS        = Y.POS<2,3>
    L.CU.FOREIGN.POS    = Y.POS<2,4>
    L.CU.DEBTOR.POS     = Y.POS<2,5>
    L.APAP.INDUSTRY.POS = Y.POS<2,6>
    L.AA.MMD.PYME.POS = Y.POS<2,7>
    L.AA.COL.POS        = Y.POS<3,1>
    L.AA.COL.VAL.POS    = Y.POS<3,2>
    L.AA.CATEG.POS      = Y.POS<4,1>
    Y.L.LOAN.STATUS.1.POS = Y.POS<5,1>
    Y.L.CR.FACILITY.POS = Y.POS<6,1>
RETURN

END
