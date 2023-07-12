SUBROUTINE LAPAP.PROCESA.ACH.ENTRANTE.RT(Y.ID.ACH.DET)
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Melvy Martinez
* PROGRAM NAME: LAPAP.PROCESA.ACH.ENTRANTE.RT
*------------------------------------------------------------------------------
*DESCRIPTION: Rutina para procesamiento de los archivos entrantes de ACH. Esta rutina esta basada en la rutina REDO.ACH.INW.INDIR.
*-------------------------------------------------------------------------------
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*13-NOV-2019      Melvy Martinez         ET-3820              Creacion de la rutina
*02-JAN-2020      Melvy Martinez                              Cambio a multi service
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_LAPAP.PROCESA.ACH.ENTRANTE.RT

    Y.OFS.SOURCE.ID = 'LAPAP.ACH.INWARD'
    Y.CARD.TYPE = 'N'
    CALL F.READ(FN.REDO.ACH.PROCESS.DET,Y.ID.ACH.DET,R.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET,Y.ERR.REDO.ACH.PROCESS.DET)

    IF R.REDO.ACH.PROCESS.DET THEN
        Y.TXN.PURPOSE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.DESCRIPTION>
        Y.TXN.CODE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.CODE>
        Y.IDENT.REJ = SUBSTRINGS(Y.TXN.CODE,2,1)
        Y.GREGORIAN.DATE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.ACCT>
        Y.ORIGINATOR.B.ID = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.B.ID>

        LOCATE Y.TXN.PURPOSE IN Y.PARAM.TXN.PURPOSE<1,1> SETTING TXN.PUR.POS THEN
            LOCATE Y.TXN.CODE IN Y.PARAM.TXN.CODE<1,TXN.PUR.POS,1> SETTING TXN.CODE.POS THEN
                Y.OFS.VERSION = Y.PARAM.TXN.VERSION<1,TXN.PUR.POS,TXN.CODE.POS>
            END
        END

        IF Y.OFS.VERSION EQ '' THEN
            DESC = 'No hay version parametrizada para el tipo de transaccion ' : Y.TXN.PURPOSE : ' y codigo ': Y.TXN.CODE :' . Transaccion: ' : Y.ID.ACH.DET
            CALL OCOMO(DESC)

            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R31'
            RETURN
        END

        IF Y.TXN.PURPOSE EQ '05' AND Y.IDENT.REJ NE '1' THEN
            Y.CARD.TYPE = 'Y'

            APP.FT = 'FUNDS.TRANSFER'
            Y.L.FT.CR.CARD.NO = 'L.FT.CR.CARD.NO'
            CALL GET.LOC.REF(APP.FT,Y.L.FT.CR.CARD.NO,L.FT.CR.CARD.NO.POS)

            R.FT<FT.CREDIT.AMOUNT> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.AMOUNT>
            R.FT<FT.LOCAL.REF,L.FT.CR.CARD.NO.POS> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ACCOUNT>
            R.FT<FT.PAYMENT.DETAILS> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.NAME>
            R.FT<FT.CREDIT.CURRENCY> = 'DOP'
            R.FT<FT.ORDERING.CUST> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.NAME>
        END ELSE
            R.FT<FT.CREDIT.AMOUNT> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.AMOUNT>
            R.FT<FT.CREDIT.ACCT.NO> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ACCOUNT>
            R.FT<FT.CREDIT.CURRENCY> = 'DOP'
            R.FT<FT.ORDERING.CUST> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ERROR.MSG>

            IF Y.IDENT.REJ EQ '1' THEN
*RECHAZOS
                CALL JULDATE(Y.GREGORIAN.DATE,JULIAN.DATE)
                JULIAN.DATE=JULIAN.DATE[3,7]
                Y.LEN = LEN(Y.ORIGINATOR.B.ID)
                Y.FINAL.PAY.DET = 'FT':JULIAN.DATE:Y.ORIGINATOR.B.ID[11,Y.LEN]
                R.FT<FT.PAYMENT.DETAILS> = Y.FINAL.PAY.DET
                R.FT<FT.CREDIT.THEIR.REF> = Y.FINAL.PAY.DET
            END ELSE
                R.FT<FT.PAYMENT.DETAILS> = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.NAME>
            END
        END

        OFS.SRC.ID = "ACH";
        OFS.MSG.ID = '';
        ERR.OFS = '';
        APP.NAME = 'FUNDS.TRANSFER'
        OFSFUNCTION = 'I';
        GTS.MODE = '' ;
        NO.OF.AUTH = '0'
        OFS.VERSION = Y.OFS.VERSION
        TRANSACTION.ID = "/" : Y.ID.ACH.DET
        OFSRECORD = ''
        PROCESS = 'PROCESS'

        CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFS.VERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.FT,OFSRECORD)

        IF OFSRECORD EQ '' THEN
            DESC = 'Error creando OFS para la transaccion ' : TRANSACTION.ID : '; OFSRECORD: ': OFSRECORD
            CALL OCOMO(DESC)
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '05'
        END ELSE

            CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE.ID,OFSRECORD,Y.OUT.MESSAGE, Y.txnCommitted)

            Y.PART.1 = FIELD(Y.OUT.MESSAGE,',',1)
            Y.FT.ID = FIELD(Y.PART.1,'/',1)
            Y.FT.ID = EREPLACE(Y.FT.ID,"<requests><request>","")
            Y.MSG.ID = FIELD(Y.PART.1,'/',2)
            Y.RESULT = FIELD(Y.PART.1,'/',3)

            CALL OCOMO('Respuesta: (' : Y.txnCommitted: ') - ': Y.FT.ID : ' Transaction ID: ' : TRANSACTION.ID)

            IF Y.RESULT EQ 1 THEN
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '02'
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.T24.TXN.ID> = Y.FT.ID
            END ELSE
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'

                IF Y.CARD.TYPE EQ 'Y' AND Y.IDENT.REJ NE '1' THEN
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R04'    ;* Fix for ACH Rejection
                END ELSE
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R31'
                END

                DESC = 'Transaccion no pudo ser procesada en T24 ' : Y.MSG.ID
                CALL OCOMO(DESC)
            END

        END

        GOSUB METHOD_ACTUALIZA_RECORD
    END

RETURN

*---------------------------
METHOD_ACTUALIZA_RECORD:
*---------------------------
    WRITE R.REDO.ACH.PROCESS.DET TO F.REDO.ACH.PROCESS.DET,Y.ID.ACH.DET ON ERROR
        CALL OCOMO('No se pudo actualizar el registro ': Y.ID.ACH.DET :' en la tabla REDO.ACH.PROCESS.DET.')

        RETURN
    END
RETURN

END
