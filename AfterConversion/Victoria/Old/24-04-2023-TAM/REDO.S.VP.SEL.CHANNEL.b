$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------

SUBROUTINE REDO.S.VP.SEL.CHANNEL (APPLICATION, PGM.VERSION, TRANS.CODE, Y.CHANNEL, Y.MON.CHANNEL)
*-----------------------------------------------------------------------------
* Developer    : Mauricio Sthandier (msthandier@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 21.10.2014
* Description  : Routine for obtaining Channel of the transaction
* Type         : SubRoutine
* Attached to  :
* Dependencies :
*---------------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who             Reference         Description
* 1.0       10.21.2014     msthandier     -                 Initial Version
*---------------------------------------------------------------------------------

* Identificar la operación en T24 a base de rutina, aplicacion y/o version
* Recuperar TRANSACTION.CODE o TRANSACTION.TYPE según TELLER o FT en el multivalor AUT.NEW.CONTENT
* Recuperar de la tabla de mapeos REDO.VPLUS.MAPPING (modificar template)

    BEGIN CASE
* Pago Caja Efectivo/TFR
        CASE APPLICATION EQ 'TELLER' AND (PGM.VERSION MATCHES '...CASHIN...' OR PGM.VERSION MATCHES '...TFR...')
            TRANS.CODE = 'TTL-TELLER'
* Pago Caja Cheque
        CASE APPLICATION EQ 'TELLER' AND PGM.VERSION MATCHES '...CHQ...'
            TRANS.CODE = 'TTL-TELLER.CHK'
* Pago por transferencias a traves de IVR
        CASE APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION MATCHES '...IVR...'
            TRANS.CODE = 'IVR-IVR'
* Pago por transferencias a traves de internet banking
* Enquiries Internet Banking
        CASE (APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION MATCHES '...PAY...') OR (PGM.VERSION MATCHES '...,AI....')
            TRANS.CODE = 'ITB-ARCIB'
* Pago por transferencias a traves de internet banking (ACH)
        CASE APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION MATCHES '...,CARD.IN'
            TRANS.CODE = 'ACH-ACH'
* Pago FT por Debitos Directos
        CASE APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION MATCHES '...DIRECT.DEBIT...'
            TRANS.CODE = 'DDD-AUTO'
* Loan Disbursement
        CASE PGM.VERSION MATCHES '...,REDO...AA...'
            TRANS.CODE = 'DBP-DBP'
* Avance en Efectivo
* Se registar en REDO.VISION.PLUS.TXN pero no se envia
        CASE APPLICATION EQ 'TELLER' AND PGM.VERSION MATCHES '...CASHWDL'
            TRANS.CODE = 'CAV-CAV'
    END CASE

    Y.CHANNEL = FIELD(TRANS.CODE,'-',1)
    Y.MON.CHANNEL = FIELD(TRANS.CODE,'-',2)

END
