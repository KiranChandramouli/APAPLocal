* @ValidationCode : MjotMjEwNzczNjIwNDpDcDEyNTI6MTY4MDY4MTE2NDEwNTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:22:44
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
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.LINKED.ID.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT

    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON

    R.AA.ARRANGEMENT = RCL$COMM.LOAN(1)   ;* AA.ARRANGEMENT Record
    LINK.POS = ''
    LOCATE 'ACCOUNT' IN R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL,1> SETTING LINK.POS THEN
        COMI = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,LINK.POS>
    END

RETURN
END
