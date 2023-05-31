$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.CLEARING.ADJ(Y.ENQ.DATA)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - SM to @SM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    LOCATE 'RETURN.STATUS' IN Y.ENQ.DATA<2,1> SETTING Y.RET.POS THEN
        Y.ENQ.DATA<3, Y.RET.POS>  = 'EQ'
        Y.ENQ.DATA<4, Y.RET.POS> = "INSUFFICIENT_BALANCE":@SM:"NOTIFICATION":@SM:"POSTING_RESTRICTION"
    END
    ELSE
        Y.ENQ.DATA<2, Y.RET.POS> = 'RETURN.STATUS'
        Y.ENQ.DATA<3, Y.RET.POS>  = 'EQ'
        Y.ENQ.DATA<4, Y.RET.POS> = "INSUFFICIENT_BALANCE":@SM:"NOTIFICATION":@SM:"POSTING_RESTRICTION"
    END

RETURN
END
