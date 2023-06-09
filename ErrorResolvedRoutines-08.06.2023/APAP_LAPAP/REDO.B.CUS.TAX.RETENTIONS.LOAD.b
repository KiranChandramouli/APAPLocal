* @ValidationCode : MjoxNzIyODkyNzg2OkNwMTI1MjoxNjg2MjE5OTg0MzM3OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Jun 2023 15:56:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
* @(#) REDO.B.CUS.TAX.RETENTIONS.LOAD Ported to jBASE 16:17:05  28 NOV 2017
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.CUS.TAX.RETENTIONS.LOAD
*------------------------------------------------------------------------------------------------------------------------------------------
*
* Description           : This Routine Used to Load and open the application .

* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN11
*
* Attached To           : Batch - BNK/REDO.B.CUS.TAX.RETENTIONS
*
* Attached As           : Online Batch Routine to COB
*--------------------------------------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*--------------------------------------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00375393           Ashokkumar.V.P                 11/12/2014            New mapping changes - Rewritten the whole source.
* APAP-132               Ashokkumar.V.P                 03/02/2016            Spliting the file based on customer identification
*                        Ghayathri                      06/06/2023            R22 Manual conversion Uncommended the line
*--------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATES
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_REDO.B.CUS.TAX.RETENTIONS.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.H.TAX.DATA.CHECKS
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_TSA.COMMON
    $INSERT I_F.BENEFICIARY
*

    GOSUB INITIALISE
    GOSUB FIND.LOCAL.REF.FLDS
    GOSUB GET.PARAM.VALS
    GOSUB TAX.DATA.CHECKS
RETURN
*
INITIALISE:
*----------
*Initialize all the files and varibles
    Y.FILE.NAME = ''; Y.FILE.DIR = ''; Y.FIELD.NAME = ''
    Y.FIELD.VAL  = ''; Y.GEN.FLG = '';  Y.FIELD.POS = ""
    Y.CR.TT.TXN.CODE = ''; Y.CHK.TT.TXN.CODE = ''; Y.CATEG.TT.TXN.CODE = ''
    Y.CR.FT.TXN.CODE = ''; Y.DR.FT.TXN.CODE = ''; Y.CHK.FT.TXN.CODE = ''
    Y.CATEG.FT.TXN.CODE = ''; Y.FX.TYPE.CODE = ''; Y.FX.CATEG = ''; Y.RCL.TXN.TAX = ''
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM  = ''
    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER  = ''
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT  = ''
    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'; F.ACCOUNT.HST = ''
    FN.TELLER = 'F.TELLER';  F.TELLER = ''
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'; F.FUNDS.TRANSFER.HIS = ''
    FN.TELLER.HIS = 'F.TELLER$HIS'; F.TELLER.HIS = ''
    FN.REDO.H.TAX.DATA.CHECKS = 'F.REDO.H.TAX.DATA.CHECKS'; F.REDO.H.TAX.DATA.CHECKS = ''
    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'; F.REDO.NCF.ISSUED = ''
    FN.AC.CHARGE.REQUEST = 'F.AC.CHARGE.REQUEST'; F.AC.CHARGE.REQUEST = ''
    FN.AC.CHARGE.REQUEST.HST = 'F.AC.CHARGE.REQUEST$HIS'; F.AC.CHARGE.REQUEST.HST = ''
    FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'; F.REDO.APAP.CLEARING.INWARD = ''
    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'; F.REDO.CLEARING.OUTWARD = ''
    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'; F.FT.COMMISSION.TYPE = ''
    FN.AC.SUB.ACC = 'F.AC.SUB.ACCOUNT' ; F.AC.SUB.ACC = ''
    FN.STMT.ENTRY = 'F.STMT.ENTRY' ; F.STMT.ENTRY = ''
    FN.DR.REG.REGN11.WORKFILE = 'F.DR.REG.REGN11.WORKFILE'; F.DR.REG.REGN11.WORKFILE =''
    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'; F.CUSTOMER.L.CU.PASS.NAT = ''
    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUSTOMER.L.CU.RNC = ''
    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUSTOMER.L.CU.CIDENT = ''
    FN.BENEFICIARY = 'F.BENEFICIARY'; F.BENEFICIARY = ''
    FN.ST.L.APAP.DG01.APAP.BEN.TXN = 'F.ST.L.APAP.DG01.APAP.BEN.TXN'; F.ST.L.APAP.DG01.APAP.BEN.TXN = ''


    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)
    CALL OPF(FN.TELLER,F.TELLER)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
    CALL OPF(FN.REDO.H.TAX.DATA.CHECKS,F.REDO.H.TAX.DATA.CHECKS)
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)
    CALL OPF(FN.AC.CHARGE.REQUEST,F.AC.CHARGE.REQUEST)
    CALL OPF(FN.AC.CHARGE.REQUEST.HST,F.AC.CHARGE.REQUEST.HST)
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    CALL OPF(FN.AC.SUB.ACC,F.AC.SUB.ACC)
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    CALL OPF(FN.DR.REG.REGN11.WORKFILE,F.DR.REG.REGN11.WORKFILE)
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)
RETURN
*
FIND.LOCAL.REF.FLDS:
*------------------
    Y.APP = "CUSTOMER":@FM:"FUNDS.TRANSFER":@FM:"TELLER":@FM:"BENEFICIARY"
    Y.FIELDS = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.PASS.NAT":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC":@VM:"L.CU.TIPO.CL":@FM:"L.TT.TAX.AMT":@VM:"L.TT.WV.TAX":@VM:"L.FT.LEGAL.ID":@FM:"L.TT.TAX.AMT":@VM:"L.TT.WV.TAX":@VM:"L.TT.LEGAL.ID":@VM:"L.TT.DOC.NUM":@VM:"L.TT.CLNT.TYPE":@VM:"L.TT.DOC.DESC":@VM:"L.TT.CLIENT.COD":@VM:"L.TT.CLIENT.NME":@VM:"L.COUNTRY":@VM:"L.ID.PERS.BENEF"
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    Y.CIDENT.POS = Y.FIELD.POS<1,1>
    Y.RNC.POS    = Y.FIELD.POS<1,2>
    Y.FORE.POS   = Y.FIELD.POS<1,3>
    L.CU.NOUNICO.POS = Y.FIELD.POS<1,4>
    L.CU.ACTANAC.POS = Y.FIELD.POS<1,5>
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,6>
    Y.FT.TAX.AMT.POS = Y.FIELD.POS<2,1>
    L.FT.WV.TAX.POS = Y.FIELD.POS<2,2>
    L.FT.LEGAL.ID.POS = Y.FIELD.POS<2,3>
    Y.TT.TAX.AMT.POS = Y.FIELD.POS<3,1>
    L.TT.WV.TAX.POS = Y.FIELD.POS<3,2>
    L.TT.LEGAL.ID.POS = Y.FIELD.POS<3,3>
    L.TT.DOC.NUM.POS = Y.FIELD.POS<3,4>
    L.TT.CLNT.TYPE.POS = Y.FIELD.POS<3,5>
    L.TT.DOC.DESC.POS = Y.FIELD.POS<3,6>
    L.TT.CLIENT.COD.POS = Y.FIELD.POS<3,7>
    L.TT.CLIENT.NME.POS = Y.FIELD.POS<3,8>
*L.COUNTRY.POS = Y.FIELD.POS<3,9>
*L.ID.PERS.BENEF.POS = Y.FIELD.POS<3,10>
*Since the  local ref position for L.ID.PERS.BENEF.POS and L.COUNTRY it's being tricky let's get it in traditional way.
    L.COUNTRY.POS = Y.FIELD.POS<3,9> ;* R22 Manual conversion Uncommended the line
    L.ID.PERS.BENEF.POS = Y.FIELD.POS<3,10>;* R22 Manual conversion Uncommended the line
    CALL GET.LOC.REF("TELLER", "L.ID.PERS.BENEF",L.ID.PERS.BENEF.POS)
    CALL GET.LOC.REF("TELLER", "L.COUNTRY",L.COUNTRY.POS)


RETURN

GET.PARAM.VALS:
*-------------
    Y.PARAM.ID = "REDO.REGN11"
    R.REDO.H.REPORTS.PARAM = ''; Y.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.FILE.NAME = Y.FILE.NAME:".TEMP.":AGENT.NUMBER:".":SERVER.NAME
        Y.APAP.ID = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.APAP.ID>
        CHANGE @VM TO '' IN Y.FILE.DIR
    END
*
    LOCATE 'TTCR' IN Y.FIELD.NAME<1,1> SETTING Y.TT.CR.POS THEN
        Y.CR.TT.TXN.CODE = Y.FIELD.VAL<1,Y.TT.CR.POS>
    END
    LOCATE 'TTCHK' IN Y.FIELD.NAME<1,1> SETTING Y.TT.CHK.POS THEN
        Y.CHK.TT.TXN.CODE = Y.FIELD.VAL<1,Y.TT.CHK.POS>
    END
    LOCATE 'TTCATEG' IN Y.FIELD.NAME<1,1> SETTING Y.TT.CATEG.POS THEN
        Y.CATEG.TT.TXN.CODE = Y.FIELD.VAL<1,Y.TT.CATEG.POS>
    END
    LOCATE 'FTCR' IN Y.FIELD.NAME<1,1> SETTING Y.FT.CR.POS THEN
        Y.CR.FT.TXN.CODE = Y.FIELD.VAL<1,Y.FT.CR.POS>
    END
    LOCATE 'FTDR' IN Y.FIELD.NAME<1,1> SETTING Y.FT.DR.POS THEN
        Y.DR.FT.TXN.CODE = Y.FIELD.VAL<1,Y.FT.DR.POS>
    END
    LOCATE 'FTCHK' IN Y.FIELD.NAME<1,1> SETTING Y.FT.CHK.POS THEN
        Y.CHK.FT.TXN.CODE = Y.FIELD.VAL<1,Y.FT.CHK.POS>
    END
    LOCATE 'FTCATEG' IN Y.FIELD.NAME<1,1> SETTING Y.FT.CATEG.POS THEN
        Y.CATEG.FT.TXN.CODE = Y.FIELD.VAL<1,Y.FT.CATEG.POS>
    END
    LOCATE 'FXTYPE' IN Y.FIELD.NAME<1,1> SETTING Y.FX.TYPE.POS THEN
        Y.FX.TYPE.CODE = Y.FIELD.VAL<1,Y.FX.TYPE.POS>
    END
    LOCATE 'FXCATEG' IN Y.FIELD.NAME<1,1> SETTING Y.FX.CATEG.POS THEN
        Y.FX.CATEG = Y.FIELD.VAL<1,Y.FX.CATEG.POS>
    END
    LOCATE 'RCL.TXN.TAX' IN Y.FIELD.NAME<1,1> SETTING Y.RCL.TXN.TAX.POS THEN
        Y.RCL.TXN.TAX = Y.FIELD.VAL<1,Y.RCL.TXN.TAX.POS>
    END

    CHANGE @SM TO @VM IN Y.CR.TT.TXN.CODE
    CHANGE @SM TO @VM IN Y.CHK.TT.TXN.CODE
    CHANGE @SM TO @VM IN Y.CATEG.TT.TXN.CODE
    CHANGE @SM TO @VM IN Y.CR.FT.TXN.CODE
    CHANGE @SM TO @VM IN Y.DR.FT.TXN.CODE
    CHANGE @SM TO @VM IN Y.CHK.FT.TXN.CODE
    CHANGE @SM TO @VM IN Y.CATEG.FT.TXN.CODE
    CHANGE @SM TO @VM IN Y.FX.TYPE.CODE
    CHANGE @SM TO @VM IN Y.FX.CATEG
    CHANGE @SM TO @VM IN Y.RCL.TXN.TAX

    R.FT.COMMISSION.TYPE = ''; ERR.COMM.TYPE = ''; YTAX.ACCT = ''; R.AC.SUB.ACC = ''; ERR.AC.SUB.ACC = ''
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.RCL.TXN.TAX, R.FT.COMMISSION.TYPE, ERR.COMM.TYPE)
    YTAX.ACCT = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
    CALL F.READ(FN.AC.SUB.ACC,YTAX.ACCT,R.AC.SUB.ACC,F.AC.SUB.ACC,ERR.AC.SUB.ACC)
RETURN
TAX.DATA.CHECKS:
*--------------
    Y.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.TAX.DATA.CHECKS,Y.ID,R.REDO.H.TAX.DATA.CHECKS,Y.TDC.ERR)
    Y.REP.GEN   = R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.REPORT.GEN>
    Y.DATE.FROM = R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.DATE.FROM>
    Y.DATE.TO   = R.REDO.H.TAX.DATA.CHECKS<REDO.TAX.DATE.TO>
*
    IF Y.DATE.FROM AND Y.DATE.TO AND Y.REP.GEN EQ 'YES' THEN
        Y.GEN.FLG = '1'
    END
    IF NOT(Y.GEN.FLG) THEN
        Y.DATE.FROM = R.DATES(EB.DAT.LAST.WORKING.DAY)[1,6]:'01'
        COMI = Y.DATE.FROM
        CALL LAST.DAY.OF.THIS.MONTH
        Y.DATE.TO = COMI
    END
RETURN
END
*--------------------------------------------------------------------------------------------------------------------------------------------
