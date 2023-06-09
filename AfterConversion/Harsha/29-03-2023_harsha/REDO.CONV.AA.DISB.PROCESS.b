* @ValidationCode : MjotMTI2MjQ0MTQyODpDcDEyNTI6MTY4MDE1Mzg2MzYwNzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 30 Mar 2023 10:54:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.AA
SUBROUTINE REDO.CONV.AA.DISB.PROCESS(Y.DISB.ID)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 29-MAR-2023      Conversion Tool       R22 Auto Conversion  - FM to @FM
* 29-MAR-2023      Harsha                R22 Manual Conversion - No changes 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CONV.AA.DISB.PROCESS.COMMON
    $INSERT I_F.REDO.DISB.CHAIN

    GOSUB PROCESS

RETURN

*********
PROCESS:
*********
    TEMP.REDO.DISB.CHAIN = ''; R.REDO.DISB.CHAIN = ''

    CALL F.READ(FN.REDO.DISB.CHAIN,Y.DISB.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,RE.DISB.ERR)
    IF R.REDO.DISB.CHAIN THEN
        TEMP.REDO.DISB.CHAIN = R.REDO.DISB.CHAIN
        R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF> = ''
        R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID> = TEMP.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF>
        R.REDO.DISB.CHAIN<DS.CH.FTTC> = TEMP.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID>
        R.REDO.DISB.CHAIN<DS.CH.CURRENCY> = TEMP.REDO.DISB.CHAIN<DS.CH.FTTC>
        R.REDO.DISB.CHAIN<DS.CH.AMOUNT> = TEMP.REDO.DISB.CHAIN<DS.CH.CURRENCY>
        R.REDO.DISB.CHAIN<DS.CH.VERSION> = TEMP.REDO.DISB.CHAIN<DS.CH.AMOUNT>
        R.REDO.DISB.CHAIN<DS.CH.TEMP.VERSION> = ''
        R.REDO.DISB.CHAIN<DS.CH.TR.STATUS> = TEMP.REDO.DISB.CHAIN<DS.CH.TEMP.VERSION>
        R.REDO.DISB.CHAIN<DS.CH.DISB.STATUS> = TEMP.REDO.DISB.CHAIN<DS.CH.VERSION>
        R.REDO.DISB.CHAIN<DS.CH.ACCOUNT> = TEMP.REDO.DISB.CHAIN<DS.CH.TR.STATUS>
        R.REDO.DISB.CHAIN<DS.CH.CUSTOMER> = TEMP.REDO.DISB.CHAIN<DS.CH.DISB.STATUS>

        WRITE R.REDO.DISB.CHAIN TO F.REDO.DISB.CHAIN,Y.DISB.ID
        CHANGE @FM TO '|' IN R.REDO.DISB.CHAIN
        WRITE R.REDO.DISB.CHAIN TO F.TEMP.FILE.PATH,Y.DISB.ID
    END
RETURN
END
