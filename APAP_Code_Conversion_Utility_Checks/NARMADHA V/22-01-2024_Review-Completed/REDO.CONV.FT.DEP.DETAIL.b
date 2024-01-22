* @ValidationCode : Mjo5OTExMTU1NzU6VVRGLTg6MTcwNTkwMTY1NzY5MzpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Jan 2024 11:04:17
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.FT.DEP.DETAIL
*---------------------------------------------------
* Description: This is conversion routine to display the Deposit Description in enquiry.
*--------------------------------------------------------------------------------
* Modification History:
* Date Reference Who Description
* 24 Jan 2012 PACS00175283 -N.45 H GANESH INITIAL DRAFT
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , SM to @SM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 22-12-2023         Narmadha V            Manual R22 Conversion   Call routine Format Modified
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON
    $USING EB.LocalReferences ;*Manual R22 Conversion

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------
OPENFILES:
*----------------------------------------------------

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.FT.MSG.DESC'
    LOC.REF.POS=''
* CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS) ;*Manual R22 Conversion - Call routine Format Modified
    POS.L.FT.MSG.DESC = LOC.REF.POS<1,1>

RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

    Y.FT.ID = O.DATA
    FT.ERR = ''
    CALL F.READ(FN.FT,Y.FT.ID,R.FT,F.FT,FT.ERR)
    IF FT.ERR THEN
        CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.FT.ID,R.FT,YERR)
    END
    Y.DEP.DETAILS = R.FT<FT.LOCAL.REF,POS.L.FT.MSG.DESC>
    CHANGE @SM TO @VM IN Y.DEP.DETAILS
    O.DATA = Y.DEP.DETAILS

RETURN
END
