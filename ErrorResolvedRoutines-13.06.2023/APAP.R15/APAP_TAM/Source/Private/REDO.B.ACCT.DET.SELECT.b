* @ValidationCode : Mjo4NTIxMzU3NzpDcDEyNTI6MTY4NTYyMTMxMTUyNzpJVFNTOi0xOi0xOi0xOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 01 Jun 2023 17:38:31
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.ACCT.DET.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine..
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00361294          Ashokkumar.V.P                  14/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*30/05/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION        T24.BP REMOVED IN INSERT FILE
*30/05/2023      HARISH VIKRAM              MANUAL R22 CODE CONVERSION      Y.CATEG.LIST added in insert file  I_REDO.B.ACCT.DET.COMMON

*----------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ACCT.DET.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*AUTO R22 CODE CONVERSION - END


    CALL EB.CLEAR.FILE(FN.DR.REG.RIEN7.WORKFILE,F.DR.REG.RIEN7.WORKFILE)
*
    CA.POS = ''; SEL.LIST = ''; NO.OF.REC1 = ''; ACC.ERR1 = ''
    SEL.CMD1 = "SELECT ":FN.ACCOUNT:" WITH CATEGORY EQ ":Y.CATEG.LIST
    CALL EB.READLIST(SEL.CMD1,SEL.LIST,'',NO.OF.REC1,ACC.ERR1)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
RETURN
END
