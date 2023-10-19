$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CK.PAYOFF
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.VER = O.DATA

    BEGIN CASE

        CASE Y.VER EQ 'FUNDS.TRANSFER,REDO.AA.PAY.OFF'
            Y.VER = 'FUNDS.TRANSFER,REDO.AA.PAY.OFF.A'

        CASE Y.VER EQ 'FUNDS.TRANSFER,REDO.MULTI.AA.ACPOAP'
            Y.VER = 'FUNDS.TRANSFER,REDO.MULTI.AA.ACPOAP.A'

        CASE Y.VER EQ 'FUNDS.TRANSFER,REDO.MULTI.AA.ACPOAP.TR'
            Y.VER = 'FUNDS.TRANSFER,REDO.MULTI.AA.ACPOAP.TR.A'

    END CASE

    O.DATA = Y.VER

RETURN

END
