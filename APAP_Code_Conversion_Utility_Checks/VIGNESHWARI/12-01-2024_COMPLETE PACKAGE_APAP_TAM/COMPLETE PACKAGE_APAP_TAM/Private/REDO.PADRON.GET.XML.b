* @ValidationCode : MjotMTcyMjQ1NjExMTpDcDEyNTI6MTcwMDQ4MDYyMzA3MjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2023 17:13:43
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------------------------
*Modification history
*Date                Who               Reference                  Description
*16-11-2023 VIGNESHWARI  ADDED COMMENT FOR INTERFACE CHANGES   No Changes
*-----------------------------------------------------------------------------------------------------
SUBROUTINE REDO.PADRON.GET.XML(LINEAEXTRAIDA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
* 16-11-2023	VIGNESHWARI       R22 Manual Code Conversion       New routine by as part of- Fix SQA-11679 Padrones
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
    Y.DFE.ID = 'REDO.PADRON.FISICO.OUT'
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
