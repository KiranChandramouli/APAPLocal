* @ValidationCode : MjoxOTYyODg1NTA4OkNwMTI1MjoxNjkxNTY0Nzk0NDk5OnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Aug 2023 12:36:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>189</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*09-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED,$INCLUDE TO $INSERT
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.OFS.BUILDER(P.APP,P.VER,P.FUNC,P.NO.OF.AUTH,P.PRO.VAL,P.GTS.CONTROL,P.USER,P.PASS,P.COMPANY,P.TXN.ID,R.DATA,O.OFS)
    $INSERT I_COMMON  ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.STANDARD.SELECTION ;*R22 MANUAL CONVERSION END
*--------------------------------------------------------------------------------
* This subroutine creates an OFS RECORD String
* By J.Q. on Aug 30 2022
*--------------------------------------------------------------------------------
* Incoming Variables
* P.APP --> Application Name, P.VER --> Version Name, P.FUNC --> OFS Function
* P.NO.OF.AUTH --> No. of Auth,  P.PRO.VAL --> OFS Process type, P.GTS.CONTROL --> GTS Control (1...4)
* P.USER --> User Name, P.PASS --> Password, P.COMPANY --> Company, P.TXN.ID --> Transaction ID
* R.DATA --> Data array
* Outgoing Variables
* O.OFS --> OFS Message
*--------------------------------------------------------------------------------
    Y.OFS.MSG = ''
*--------------------------------------------------------------------------------
    FN.SS = "F.STANDARD.SELECTION"
    FV.SS = ""
    R.SS = ""
    SS.ERR = ""
    CALL OPF(FN.SS,FV.SS)
*--------------------------------------------------------------------------------
    CALL F.READ(FN.SS,P.APP,R.SS,FV.SS,SS.ERR)

*--------------------------------------------------------------------------------

    Y.OFS.MSG := P.APP : ',' : P.VER
    CHANGE ',,' TO ',' IN Y.OFS.MSG

    Y.OFS.MSG := '/' : P.FUNC : '/' : P.PRO.VAL

    IF P.GTS.CONTROL NE '' THEN
        IF P.NO.OF.AUTH NE '' THEN
            Y.OFS.MSG :=  '/' : P.GTS.CONTROL : '/': P.NO.OF.AUTH :',' : P.USER : '/' : P.PASS : ','
        END ELSE
            Y.OFS.MSG :=  '/' : P.GTS.CONTROL : ',' : P.USER : '/' : P.PASS : ','
        END
    END ELSE
        IF P.NO.OF.AUTH NE '' THEN
            Y.OFS.MSG :=  '//': P.NO.OF.AUTH :',' : P.USER : '/' : P.PASS
        END ELSE
            Y.OFS.MSG :=  ',' : P.USER : '/' : P.PASS
        END

    END

    IF P.COMPANY NE '' THEN
        Y.OFS.MSG := '/' : P.COMPANY : ','
    END ELSE
        Y.OFS.MSG := ','
    END

    IF P.TXN.ID NE '' THEN
        Y.OFS.MSG := P.TXN.ID : ','
    END ELSE
        Y.OFS.MSG := ','
    END

    Y.CNT.FM = DCOUNT(R.DATA, @FM)
    Y.FLD.NO.ARR = R.SS<SSL.SYS.FIELD.NO>
    Y.FLD.NAME.ARR = R.SS<SSL.SYS.FIELD.NAME>
    FOR A = 1 TO Y.CNT.FM STEP 1
        IF R.DATA<A> NE '' THEN
            FIND A IN Y.FLD.NO.ARR SETTING v.Fld, v.Val THEN
*CRT A: " is in field: " : v.Fld, "value: ": v.Val
*CRT A: " Field name is : " : Y.FLD.NAME.ARR<1,v.Val>
                Y.FLD.NAME = Y.FLD.NAME.ARR<1,v.Val>
                Y.FLD.VALUE = R.DATA<A>
                Y.QTY.SM = DCOUNT(Y.FLD.VALUE,@VM)
                IF Y.QTY.SM EQ 0 THEN
                    Y.OFS.MSG := Y.FLD.NAME : "1:1=" : Y.FLD.VALUE : ","
                END ELSE
                    FOR SMCOUNTER = 1 TO Y.QTY.SM STEP 1
                        IF Y.FLD.VALUE<1,SMCOUNTER> NE '' THEN
                            Y.OFS.MSG := Y.FLD.NAME : ":" : SMCOUNTER : ":1=" : Y.FLD.VALUE<1,SMCOUNTER> : ","
                        END
                    NEXT SMCOUNTER
                END

            END
        END

    NEXT A
    O.OFS = Y.OFS.MSG
*DEBUG
END
