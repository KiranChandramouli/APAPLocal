* @ValidationCode : MjotMjMyNTQ0MTc0OkNwMTI1MjoxNjg0ODU2ODcwOTMyOklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , $INCLUDE TAM.BP REM0VED
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.GET.ACCOUNTING.HEAD(ACCOUNTING.HEAD,L.ASSET.TYPE)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AZACC.DESC   ;*R22 AUTO CODE CONVERSION
    ACCOUNT.HEAD = ACCOUNTING.HEAD
    ACCOUNTING.HEAD = ''
    NO.OF.AT =  DCOUNT(L.ASSET.TYPE,@FM) ;*R22 AUTO CODE CONVERSION
    FOR IAT = 1 TO NO.OF.AT
        CHK.ASSET =  L.ASSET.TYPE<IAT>
        FMPOS =  '' ; VMPOS = '' ; SMPOS  = ''
        FIND CHK.ASSET IN ACCOUNT.HEAD SETTING FMPOS,VMPOS,SMPOS THEN
            ACCOUNTING.HEAD = ACCOUNT.HEAD<AZACC.DESC,VMPOS>
            EXIT
        END
    NEXT IAT
RETURN
