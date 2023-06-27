* @ValidationCode : MjotNDU2MzcwNzg6Q3AxMjUyOjE2ODQ4NTY4NzI5MzQ6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
