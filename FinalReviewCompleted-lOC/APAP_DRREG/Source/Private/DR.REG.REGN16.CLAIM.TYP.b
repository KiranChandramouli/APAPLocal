* @ValidationCode : MjotNDU2MzcwNzg6Q3AxMjUyOjE2ODA2OTUwODU3MjE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 17:14:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.REGN16.CLAIM.TYP
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
* 31-07-2014        Ashokkumar                PACS00366332- Initial revision

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.U.CRM.CLAIM.TYPE

    YCLAIM.TYPE = COMI


    FN.REDO.U.CRM.CLAIM.TYPE = 'F.REDO.U.CRM.CLAIM.TYPE'
    F.REDO.U.CRM.CLAIM.TYPE = ''
    CALL OPF(FN.REDO.U.CRM.CLAIM.TYPE,F.REDO.U.CRM.CLAIM.TYPE)

    R.REDO.U.CRM = ''; REDO.CRM.ERR = ''
    CALL F.READ(FN.REDO.U.CRM.CLAIM.TYPE,YCLAIM.TYPE,R.REDO.U.CRM,F.REDO.U.CRM.CLAIM.TYPE,REDO.CRM.ERR)
    C.VAL = R.REDO.U.CRM<CLAIM.TYPE.L.CLAIM.TYPE>
    COMI = FMT(C.VAL,"L#4")
RETURN
END
