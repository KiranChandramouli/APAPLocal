* @ValidationCode : MjoxODMyNjcyMjc6Q3AxMjUyOjE2OTg0MDU1NDAwMjA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:49:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*--------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>2505</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MAP.SWIFT.LBTR(MISN, R.MSG, GENERIC.DATA, ROUTINE.ERR.MSG)
        

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                  Nochanges
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.DE.HEADER
    $INSERT I_DEOCOM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DE.INTERFACE

    FN.DE.O.MSG.LBTR = "F.DE.O.MSG.LBTR"
    F.DE.O.MSG.LBTR = ""
    CALL OPF(FN.DE.O.MSG.LBTR,F.DE.O.MSG.LBTR)

    FN.DE.INTERFACE = "F.DE.INTERFACE"
    F.DE.INTERFACE = ""
    CALL OPF(FN.DE.INTERFACE,F.DE.INTERFACE)

    IS.PAYROLL = 0
    LBTR = @FALSE
    IF LEN(MISN) GT 10 THEN
        MISN = MISN[1,10]
    END


    IF R.HEAD(DE.HDR.MESSAGE.TYPE) = 103 AND R.HEAD(DE.HDR.APPLICATION) = "FTOT" THEN
        GOSUB CHECK.FT
        IF  LBTR = @TRUE THEN
            CRLF = CHAR(13):CHAR(10)
            MY.REC = R.MSG
            CHANGE CRLF TO @FM IN MY.REC
            CHANGE "{108:xxxxx}" TO "{103:SDD}" IN MY.REC
            ID.TRANS = FIELD(MISN,".",1)
            CHANGE ".SN...ISN." TO ID.TRANS IN MY.REC

*/53B Processing*/
            FINDSTR ":53B:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                DEL MY.REC<POS>
            END

*/57D Processing*/
            POS = 0
            FINDSTR ":57D:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                IF BIC.BANK[1,2] = "SW" THEN
                    SEND.BANK = FIELD(BIC.BANK,".",2)[1,8]
                    CHANGE "BCRDDOSP" TO SEND.BANK IN MY.REC<1>
                    DEL MY.REC<POS>
                END ELSE
                    CHANGE "57D" TO "54A" IN MY.REC<POS>
                END
            END
*/57A Processing*/

            FINDSTR ":57A:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                IF BIC.BANK[1,2] = "SW" THEN
                    SEND.BANK = FIELD(BIC.BANK,".",2)[1,8]
                    CHANGE "BCRDDOSP" TO SEND.BANK IN MY.REC<1>
                    DEL MY.REC<POS>
                END ELSE
                    CHANGE "57A" TO "54A" IN MY.REC<POS>
                END
            END
*/20 Processing*/

            FINDSTR ":20:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                IF  IS.PAYROLL EQ 1 THEN
                    NEW.TRANS.REF = "E000073.A":ID.FT[6,4]
                END
                ELSE
                    NEW.TRANS.REF = "E000073.":ID.FT[6,5]
                END
                MY.REC<POS> = ":20:":NEW.TRANS.REF
            END
*/21 Processing*/

            FINDSTR ":21:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                DEL MY.REC<POS>
            END

*/32A Processing*/
            FINDSTR ":32A:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                Y.DATE = TODAY[3,6]
                Y.NEXT.DATE = TODAY
                CALL CDT("",Y.NEXT.DATE,'+1W')
                Y.CUT.OF.TIME = 17 * 60 * 60
                Y.CURRENT.TIME = TIME()
                Y.CURRENT.DATE = OCONV(DATE(), 'DG')
                IF  TODAY EQ Y.CURRENT.DATE THEN
                    IF  Y.CURRENT.TIME GT  Y.CUT.OF.TIME THEN
                        Y.DATE =Y.NEXT.DATE[3,6]
                    END
                END
                IF  TODAY LT Y.CURRENT.DATE THEN
                    Y.DATE =Y.NEXT.DATE[3,6]
                END
                MY.REC<POS>= ":32A:":Y.DATE: MY.REC<POS>[12,99]
            END


*/72 Processing*/

            FINDSTR ":72:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                Y.PP = "//"
                FOR I.G = 1  TO 4
                    IF MY.REC<POS+I.G>[1,5] EQ "/REC/" THEN
                        CHANGE "/REC/" TO "" IN MY.REC<POS+I.G>
                        IF MY.REC<POS+I.G> NE "" THEN
                            MY.REC<POS+I.G> = Y.PP :  MY.REC<POS+I.G>
                            Y.PP := "/"
                        END
                        ELSE
                            MY.REC<POS+I.G> = "DELETE.THIS"
                        END
                    END

                NEXT I.G

            END
            FINDSTR "DELETE.THIS" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                DEL MY.REC<POS>
            END

*/59B Processing*/
            FINDSTR ":59B:" IN MY.REC SETTING POS ELSE POS = 0
            IF POS THEN
                CHANGE ":59B:" TO ":59:" IN MY.REC<POS>
            END


            CHANGE @FM TO CRLF IN MY.REC
            R.MSG = MY.REC
            ID.MSG = "MSG":MISN:".fin"
            CALL F.WRITE(FN.DE.O.MSG.LBTR,ID.MSG,R.MSG)
            CALL F.READ(FN.DE.INTERFACE,"LBTR",R.DE.INTERFACE,F.DE.INTERFACE,E.DE.INTERFACE)
            IF NOT(E.DE.INTERFACE) AND R.DE.INTERFACE<DE.ITF.FILE.PATHNAME> NE "" THEN
                FN.LBTR.FILE.OUT = R.DE.INTERFACE<DE.ITF.FILE.PATHNAME>

                FILE.OUT = ""

                OPENSEQ FN.LBTR.FILE.OUT,ID.MSG TO FILE.OUT ELSE
                    CREATE FN.LBTR.FILE.OUT THEN
                    END
                END

                WRITESEQ R.MSG ON FILE.OUT ELSE RETURN
            END
        END
    END

    RETURN

*********
CHECK.FT:
*********

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER$HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER$HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

    TRANS.REF = R.HEAD(DE.HDR.TRANS.REF)
    IF TRANS.REF[1,1] = 1 THEN TRANS.REF = TRANS.REF[2,99]

    IF TRANS.REF THEN
        R.FT = ""
        ER = ""
        CALL F.READ(FN.FUNDS.TRANSFER,TRANS.REF,R.FT,F.FUNDS.TRANSFER,ER)
        IF ER THEN
            CALL F.READ.HISTORY(FN.FUNDS.TRANSFER$HIS,TRANS.REF,R.FT, F.FUNDS.TRANSFER$HIS, ER)
        END
        IF R.FT THEN
            BIC.BANK = "" ; ACCT.BANK = ""
            ID.FT = TRANS.REF[3,99]

            TRANS.TYPE = R.FT<FT.TRANSACTION.TYPE>
            BIC.BANK   = R.FT<FT.ACCT.WITH.BANK>
            ACCT.BANK  = R.FT<FT.BEN.ACCT.NO>
            IS.PAYROLL = 0
            IF R.FT<FT.ORD.CUST.ACCT> NE "" THEN
                IS.PAYROLL=1
            END
            IF TRANS.TYPE[1,3] = "OT3" THEN
                LBTR = @TRUE
            END
        END
    END

    RETURN
