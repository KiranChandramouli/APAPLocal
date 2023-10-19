* @ValidationCode : MjoyMDA5MDA1NzY3OkNwMTI1MjoxNjk3MDI5MzA3NTA5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Oct 2023 18:31:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM


SUBROUTINE REDO.B.TAXPAYER.SERVICES.LOAD
*------------------------------------------------------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about Sales of Goods and / or Services made by the taxpayer during the fiscal period ended

* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : Batch - BNK/REDO.B.TAXPAYER.SERVICES
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
*
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula

** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_REDO.B.TAXPAYER.SERVICES.COMMON ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
*    $INSERT T24.BP I_BATCH
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.TELLER ;* R22 Auto conversion
    $INSERT I_F.FUNDS.TRANSFER ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.RAD.CONDUIT.LINEAR ;* R22 Auto conversion
    $INSERT I_F.REDO.NCF.ISSUED ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
*   $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.CATEG.ENTRY ;* R22 Auto conversion
*
    GOSUB INITIALISE
*
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
INITIALISE:
*----------
*Initialize all the files and varibles
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM  = ''
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
*
    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
*
    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
*
    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS  = ''
*
    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED = ''
*
    FN.RAD.CONDUIT.LINEAR = 'F.RAD.CONDUIT.LINEAR'
    F.RAD.CONDUIT.LINEAR  = ''
    FN.CUSTOMER.HST = 'F.CUSTOMER$HIS'
    F.CUSTOMER.HST  = ''
*
    FN.CATEG.ENTRY = 'FBNK.CATEG.ENTRY'
    F.CATEG.ENTRY = ''
*
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.TELLER,F.TELLER)
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)
    CALL OPF(FN.RAD.CONDUIT.LINEAR,F.RAD.CONDUIT.LINEAR)
    CALL OPF(FN.CUSTOMER.HST,F.CUSTOMER.HST)
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)

    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'; F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)

    FN.DR.REG.REGN9.WORKFILE = 'F.DR.REG.REGN9.WORKFILE'; F.DR.REG.REGN9.WORKFILE =''
    CALL OPF(FN.DR.REG.REGN9.WORKFILE,F.DR.REG.REGN9.WORKFILE)

    FN.FT.COMMISSION.TYPE = "F.FT.COMMISSION.TYPE";   F.FT.COMMISSION.TYPE = ""
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.CHARGE.PARAM = 'F.REDO.CHARGE.PARAM'; F.CHARGE.PARAM = ''
    CALL OPF(FN.CHARGE.PARAM,F.CHARGE.PARAM)

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'; F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.CATEGORY = 'F.CATEGORY'; F.CATEGORY =''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    Y.APP = "CUSTOMER":@FM:"FUNDS.TRANSFER":@FM:"CATEGORY"
    Y.FIELDS = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.PASS.NAT":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC":@FM:"ITBIS.COM.VAL":@VM:"AT.UNIQUE.ID":@VM:"L.FT.CHANNELS":@VM:"L.TT.TAX.CODE":@FM:"L.TYPE.PROFIT"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    Y.CIDENT.POS = Y.FIELD.POS<1,1>
    Y.RNC.POS    = Y.FIELD.POS<1,2>
    Y.FORE.POS   = Y.FIELD.POS<1,3>
    L.CU.NOUNICO.POS = Y.FIELD.POS<1,4>
    L.CU.ACTANAC.POS = Y.FIELD.POS<1,5>
    Y.ITBIS.POS  = Y.FIELD.POS<2,1>
    AT.UNIQUE.ID.POS = Y.FIELD.POS<2,2>
    L.FT.CHANNELS.POS = Y.FIELD.POS<2,3>
    L.TT.TAX.CODE.POS = Y.FIELD.POS<2,4>
    L.TYPE.PROFIT.POS = Y.FIELD.POS<3,1>
*
    Y.LAST.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.PARAM.ID = "REDO.REGN9"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.ID    = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL  = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.DATE.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.YEAR.MONTH>
        Y.FREQ.REQ = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FREQUENCY.REQ>
        BEGIN CASE
            CASE Y.DATE.REQ AND Y.FREQ.REQ EQ 'Yearly'
                Y.DATE.REQ = Y.DATE.REQ[1,4]
            CASE Y.DATE.REQ AND Y.FREQ.REQ EQ 'Monthly'
                Y.DATE.REQ = Y.DATE.REQ[1,6]
            CASE Y.FREQ.REQ EQ 'Yearly'
                Y.DATE.REQ = Y.LAST.DAY[1,4]
            CASE (Y.FREQ.REQ EQ 'Monthly') OR Y.FREQ.REQ EQ ''
                Y.DATE.REQ = Y.LAST.DAY[1,6]
        END CASE
    END
*
    Y.FILE.NAME = Y.FILE.ID:".TEMP.":AGENT.NUMBER:".":SERVER.NAME ;* R22 Auto conversion
    CHANGE @VM TO '' IN Y.FILE.DIR
*
    Y.RCL.ID = "REDO.RCL.REGN9.HR"
    CALL F.READ(FN.RAD.CONDUIT.LINEAR,Y.RCL.ID,R.RAD.CONDUIT.LINEAR,F.RAD.CONDUIT.LINEAR,Y.ERR)
*
    IF R.RAD.CONDUIT.LINEAR NE '' THEN
        Y.RCL.IN.POS     = R.RAD.CONDUIT.LINEAR<RAD.CON.LIN.IN.POSITION>
        Y.RCL.CONV.FUNC  = R.RAD.CONDUIT.LINEAR<RAD.CON.LIN.CONV.FUNC>
        Y.RCL.CONV.PARAM = R.RAD.CONDUIT.LINEAR<RAD.CON.LIN.CONV.PARAM>
*
        LOCATE 'APAP.ID' IN Y.RCL.IN.POS<1,1> SETTING ID.POS THEN
            Y.RCL.APAP.ID = Y.RCL.CONV.PARAM<1,ID.POS>
        END
    END
RETURN

END
*--------------------------------------------------------------------------------------------------------------------------------------------
