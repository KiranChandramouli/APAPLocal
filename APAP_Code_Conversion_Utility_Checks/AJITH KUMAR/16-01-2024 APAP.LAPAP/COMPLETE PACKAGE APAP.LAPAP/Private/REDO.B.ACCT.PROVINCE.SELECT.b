* @ValidationCode : MjotMTM4OTA0NjQwOkNwMTI1MjoxNjgyMzMxNTY1NDExOklUU1M6LTE6LTE6LTEzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.ACCT.PROVINCE.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .SELECT Subroutine.
*
*-------------------------------------------------------------------------------
* Modification History
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
*                       Ashokkumar.V.P                  17/02/2016           Changes to avoid the customer data issue

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, INSERT file folder name removed T24.BP, LAPAP.BP
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------
    $INSERT I_COMMON                            ;** R22 Auto conversion
    $INSERT I_EQUATE                            ;** R22 Auto conversion
    $INSERT I_F.COMPANY                         ;** R22 Auto conversion
    $INSERT I_REDO.B.ACCT.PROVINCE.COMMON       ;** R22 Auto conversion
   $USING EB.Service

    GOSUB INIT
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*------------
*    CALL EB.CLEAR.FILE(FN.DR.REG.PROV.WORKFILE, F.DR.REG.PROV.WORKFILE)
EB.Service.ClearFile(FN.DR.REG.PROV.WORKFILE, F.DR.REG.PROV.WORKFILE);* R22 UTILITY AUTO CONVERSION

    SEL.COMP = "SSELECT ":FN.COMPANY
    CALL EB.READLIST(SEL.COMP,SEL.CLIST,'',REC.CLST,SEL.ERR)

    LOOP
        REMOVE COMP.ID FROM SEL.CLIST SETTING CMP.POSN
    WHILE COMP.ID:CMP.POSN
        YMNEMONIC = ''; ERR.COMP = ''; R.COMPANY1 = ''
        CALL CACHE.READ(FN.COMPANY,COMP.ID,R.COMPANY1,ERR.COMP)
        YMNEMONIC = R.COMPANY1<EB.COM.MNEMONIC>

        FN.RE.CRF.MBGL = 'F':YMNEMONIC:'.RE.CRF.MBGL'
        SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''
        SEL.CMD = "SELECT ":FN.RE.CRF.MBGL:" WITH DESC.1 LIKE 12... OR DESC.1 LIKE 2... OR DESC.1 LIKE 17..."
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        SEL.FIN.LST<-1> = SEL.LIST
    REPEAT
*    CALL BATCH.BUILD.LIST("",SEL.FIN.LST)
EB.Service.BatchBuildList("",SEL.FIN.LST);* R22 UTILITY AUTO CONVERSION
RETURN

INIT:
*****
    SEL.COMP = ''; SEL.CLIST = ''; REC.CLST = ''; SEL.LIST = ''
    SEL.ERR = ''; SEL.FIN.LST = ''; CMP.POSN = ''
RETURN
END
