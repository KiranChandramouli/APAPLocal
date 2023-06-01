$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.REGN16.DISTRIB.CHANNEL
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    DISTRIB.CHANNEL = COMI
    BEGIN CASE
        CASE DISTRIB.CHANNEL EQ 'E.BANKING'
            DIS.VAL = 'EB'
        CASE DISTRIB.CHANNEL EQ 'CAJEROS.AUTOMATICOS'
            DIS.VAL = 'CA'
        CASE DISTRIB.CHANNEL EQ 'IVR'
            DIS.VAL = 'IV'
        CASE DISTRIB.CHANNEL EQ 'VENTANILLA'
            DIS.VAL = 'VE'
        CASE DISTRIB.CHANNEL EQ 'PROCESO.INTERNO.AUTOMATIZADO'
            DIS.VAL = 'PA'
        CASE DISTRIB.CHANNEL EQ 'PROCESO.INTERNO.POR.ERROR.MANUAL'
            DIS.VAL = 'PM'
        CASE DISTRIB.CHANNEL EQ 'PUNTO.DE.SERVICIO.MOVILl'
            DIS.VAL = 'SM'
        CASE DISTRIB.CHANNEL EQ 'ACH'
            DIS.VAL = 'AC'
        CASE DISTRIB.CHANNEL EQ 'POS'
            DIS.VAL = 'PO'
    END CASE
    COMI = DIS.VAL
RETURN
END
