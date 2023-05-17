*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.REGN22.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.REGN22.EXTRACT
* Date           : 10-May-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* * This multi-thread job is meant for to extact the securities happened on daily basis
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.REGN22.EXTRACT.COMMON

    GOSUB INIT.PROCESS

RETURN

*-----------------------------------------------------------------------------
INIT.PROCESS:
*-----------*

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)

    FN.DR.REG.REGN22.WORKFILE = 'F.DR.REG.REGN22.WORKFILE'
    F.DR.REG.REGN22.WORKFILE = ''
    CALL OPF(FN.DR.REG.REGN22.WORKFILE,F.DR.REG.REGN22.WORKFILE)
*
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LAST.WORK.DAY = R.DATES(EB.DAT.TODAY)

* PACS00305215
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
*
    LOC.APP = 'CUSTOMER'
    LOC.FLD = 'L.CU.RNC':@FM:'L.CU.FOREIGN'          ;* added by M.Medina
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APP,LOC.FLD,LOC.POS)
    L.CU.RNC.POS = LOC.POS<1,1>
    L.CU.FOREIGN.POS = LOC.POS<1,2>
* PACS00305215

RETURN
*-----------------------------------------------------------------------------
END
