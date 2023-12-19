* @ValidationCode : MjoxNzUzODgxMDM1OkNwMTI1MjoxNzAwNDkwNTM3NzMyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Nov 2023 19:58:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISION.PLUS.GET.XML(LINEAEXTRAIDA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DFE.TRANSFORM
    
    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    Y.DFE.ID = 'REDO.VP.CONSULTA.BALANCE.OUT'
    RESPONSE.XML = ''
    
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    RESPONSE.XML = LINEAEXTRAIDA<2>
    IF NOT(RESPONSE.XML) THEN
        RESPONSE.XML = LINEAEXTRAIDA
    END
    SUCCESS.FLAG = RESPONSE.XML[":<",1,1]
    IF SUCCESS.FLAG NE 'Success' THEN
        LINEAEXTRAIDA = 'ERROR'
    END ELSE
        Y.RESPONSE = RESPONSE.XML[":<",2,1]
        Y.RESPONSE = '<':Y.RESPONSE
        CALL F.READ(FN.DFE.TRANSFORM, Y.DFE.ID, R.DFE.TRANSFORM, F.DFE.TRANSFORM, Y.DFE.TRANSFORM.ERROR)
        IF Y.DFE.TRANSFORM.ERROR EQ '' THEN
            RESP.XSLT = R.DFE.TRANSFORM<DFE.TRANS.XSLT.MAPPING>
            FINAL.RESPONSE = ''
            LINEAEXTRAIDA = XMLTOXML(Y.RESPONSE, RESP.XSLT, FINAL.RESPONSE)
            LINEAEXTRAIDA = TRIM(LINEAEXTRAIDA, ' ', 'B')
            LINEAEXTRAIDA = FIELDS(LINEAEXTRAIDA,'^',2)
            CHANGE '|' TO @FM IN LINEAEXTRAIDA
            Y.TOT.VAL = DCOUNT(LINEAEXTRAIDA,@FM)
            I = 1
            LOOP
            WHILE I LE Y.TOT.VAL
                Y.TEMP = LINEAEXTRAIDA<I>:' '
                Y.LINE.TMP<I> = TRIM(Y.TEMP)
                I++
            REPEAT
            LINEAEXTRAIDA = Y.LINE.TMP
        END
    END
RETURN

END
