* @ValidationCode : MjoxMTIwMjc1ODgzOkNwMTI1MjoxNjg0ODU2ODczMDY2OklUU1M6LTE6LTE6Mzg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 386
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
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
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*06-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*06-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

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
