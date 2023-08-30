* @ValidationCode : MjotMTcxNjcyMDMyODpDcDEyNTI6MTY4MTc5NDUxNTM3MjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:38:35
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CAPL.B.BUILD.LINE.CONT(RE.STAT.LINE.CONT.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPL.B.BUILD.LINE.CONT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a BATCH routine, this routine takes backup of the record from the file RE.STAT.LINE.CONT
*                    inorder to extract the back dated reports from the system
*Linked With       : Batch BNK/RE.BUILD.SLC
*In  Parameter     : RE.STAT.LINE.CONT.ID - Id of file RE.STAT.LINE.CONT
*Out Parameter     : NA
*Files  Used       : READ.RE.STAT.LINE.CONT            As              I               Mode
*                    REDO.CAPL.L.RE.STAT.LINE.CONT     As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 26 Oct 2010       Shiva Prasad Y       ODR-2009-12-0294 C.12         Initial Creation
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.REDO.CAPL.L.RE.STAT.LINE.CONT
    $INSERT I_REDO.CAPL.B.BUILD.LINE.CONT.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    GOSUB READ.RE.STAT.LINE.CONT
    IF NOT(R.RE.STAT.LINE.CONT) THEN
        RETURN
    END
    Y.NEXT.LINE.BAL.DATE=R.DATES(EB.DAT.TODAY)
    REDO.CAPL.L.RE.STAT.LINE.CONT.ID = RE.STAT.LINE.CONT.ID:'-':Y.NEXT.LINE.BAL.DATE
    R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.ASST.CONSOL.KEY>  = R.RE.STAT.LINE.CONT<RE.SLC.ASST.CONSOL.KEY>
    R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.ASSET.TYPE>       = R.RE.STAT.LINE.CONT<RE.SLC.ASSET.TYPE>
    R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.PRFT.CONSOL.KEY>  = R.RE.STAT.LINE.CONT<RE.SLC.PRFT.CONSOL.KEY>
    R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.PROFIT.CCY>       = R.RE.STAT.LINE.CONT<RE.SLC.PROFIT.CCY>
    R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.DATE.UPDATED>     = Y.NEXT.LINE.BAL.DATE

*    IF (R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.ASST.CONSOL.KEY> NE '') OR  (R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.ASSET.TYPE> NE '') OR (R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.PRFT.CONSOL.KEY> NE '') OR (R.REDO.CAPL.L.RE.STAT.LINE.CONT<CAPL.L.RE.CONT.PROFIT.CCY> NE '') THEN
    GOSUB WRITE.REDO.CAPL.L.RE.STAT.LINE.CONT
*    END

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
READ.RE.STAT.LINE.CONT:
***********************
* In this para of the code, file RE.STAT.LINE.CONT is read
    R.RE.STAT.LINE.CONT  = ''
    RE.STAT.LINE.CONT.ER = ''
    CALL F.READ(FN.RE.STAT.LINE.CONT,RE.STAT.LINE.CONT.ID,R.RE.STAT.LINE.CONT,F.RE.STAT.LINE.CONT,RE.STAT.LINE.CONT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
************************************
WRITE.REDO.CAPL.L.RE.STAT.LINE.CONT:
************************************
    CALL F.WRITE(FN.REDO.CAPL.L.RE.STAT.LINE.CONT,REDO.CAPL.L.RE.STAT.LINE.CONT.ID,R.REDO.CAPL.L.RE.STAT.LINE.CONT)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* ENd of Program
