* @ValidationCode : MjoxMjUyMDYwMjUyOkNwMTI1MjoxNjgxNzk0NzYxNTQzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:42:41
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
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.EVA.LOAD
*-----------------------------------------------------------------------------
* Initialize COMMON variables and Open required files
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-04-07 : avelasco@temenos.com
*                                   First version
*REM Just for compile
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.CCRG.B.EVA.COMMON
*-----------------------------------------------------------------------------
* Open files to be used in the XX routine as well as standard variables


* Customer Application

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

* Local fields from Customer Application

    Y.APPL = 'CUSTOMER'
    Y.FIELDS = 'L.CU.GRP.RIESGO'
    Y.POS.FIELD = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELDS,Y.POS.FIELD)
    L.CU.GRP.RIESGO.POS = Y.POS.FIELD<1,1>

* List Risk Limit by the Customer

    FN.REDO.CCRG.RL.CUSTOMER = 'F.REDO.CCRG.RL.CUSTOMER'
    F.REDO.CCRG.RL.CUSTOMER  = ''
    CALL OPF(FN.REDO.CCRG.RL.CUSTOMER,F.REDO.CCRG.RL.CUSTOMER)

    FN.REDO.CCRG.CUSTOMER = 'F.REDO.CCRG.CUSTOMER'
    F.REDO.CCRG.CUSTOMER  = ''
    CALL OPF(FN.REDO.CCRG.CUSTOMER,F.REDO.CCRG.CUSTOMER)

* Risk Limit Parameters

    FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
    F.REDO.CCRG.RISK.LIMIT.PARAM  = ''
    CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM)

*List of the Related Customer by Risk Limit

    FN.REDO.CCRG.RL.REL.CUS  = 'F.REDO.CCRG.RL.REL.CUS'
    F.REDO.CCRG.RL.REL.CUS   = ''
    CALL OPF(FN.REDO.CCRG.RL.REL.CUS,F.REDO.CCRG.RL.REL.CUS)

* Main process input queue - Job List

    FN.REDO.CCRG.EVA.QUEUE = 'F.REDO.CCRG.EVA.QUEUE'
    F.REDO.CCRG.EVA.QUEUE = ''
    CALL OPF(FN.REDO.CCRG.EVA.QUEUE,F.REDO.CCRG.EVA.QUEUE)

* Main process output queue - Job List

    FN.REDO.CCRG.EXT.QUEUE = 'F.REDO.CCRG.EXT.QUEUE'
    F.REDO.CCRG.EXT.QUEUE = ''
    CALL OPF(FN.REDO.CCRG.EXT.QUEUE,F.REDO.CCRG.EXT.QUEUE)

* Get the list of Risk.Limits

    Y.SEL.CMD = "SELECT " : FN.REDO.CCRG.RISK.LIMIT.PARAM : ' WITH APPLICATION NE ' : "'":"'"
    CALL EB.READLIST(Y.SEL.CMD,R.RL.LIST,'',NO.OF.RISK.LIM,Y.ERR3)
RETURN
*-----------------------------------------------------------------------------

END
