* @ValidationCode : MjoxMzQxODQ0NDI6Q3AxMjUyOjE2ODQ4MzYwNDI2OTY6SVRTUzotMTotMToyNTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 258
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   I to I.VAR , VM to @VM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.INSURANCE.SEQ.POL.NUM
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type : Validation
* Attached to     : APAP.H.INSURANCE.DETAILS,REDO.INGRESO
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : 2011-05-18
* Amended by      : ejijon@temenos.com
* Date            : 2011-10-26
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.APAP.H.COMP.NAME

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

*
RETURN
*
* ======
PROCESS:
* ======

*IF Y.CLASS.POLICY EQ "GROUP" OR  THEN
*CALL F.READU(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME,P)
*CALL F.READU(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME,0)
*CALL F.READ(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME, F.COMP.NAME, Y.ERR.COMP.NAME)

    READ R.COMP.NAME FROM F.COMP.NAME,Y.COMP.NAME.ID THEN

        FIELDS.NO = DCOUNT(R.COMP.NAME<REDO.CMP.CLASS.POLICY>,@VM)

        W.CLASS.POLICY = R.COMP.NAME<REDO.CMP.CLASS.POLICY>
        W.POLICY.TYPE = R.COMP.NAME<REDO.CMP.INS.POLICY.TYPE>

        FOR I.VAR=1 TO FIELDS.NO ;*R22 AUTO CODE CONVERSION
            IF W.POLICY.TYPE<1,I.VAR> EQ Y.POLICY.TYPE AND W.CLASS.POLICY<1,I.VAR> EQ Y.CLASS.POLICY THEN
                Y.SEN.POLICY.NUMBER = R.COMP.NAME<REDO.CMP.SEN.POLICY.NUMBER,I.VAR>
                Y.MAX.SEN.POL.NUM = R.COMP.NAME<REDO.CMP.MAX.POLICY.NUMBER,I.VAR>
                R.COMP.NAME<REDO.CMP.MAX.POLICY.NUMBER,I.VAR> = Y.MAX.SEN.POL.NUM + 1
*CALL F.WRITE(FN.COMP.NAME, Y.COMP.NAME.ID, R.COMP.NAME)
                WRITE R.COMP.NAME TO F.COMP.NAME,Y.COMP.NAME.ID
            END
        NEXT

        IF Y.MAX.SEN.POL.NUM EQ '' THEN
            Y.NEXT.SEN.POL.NUM = 1
        END ELSE
            Y.NEXT.SEN.POL.NUM = Y.MAX.SEN.POL.NUM + 1
        END

        W.NUM.CEROS = 6 - LEN(Y.NEXT.SEN.POL.NUM)
        FOR I.VAR = 1 TO W.NUM.CEROS
            W.CEROS = '0' : W.CEROS
        NEXT

        IF R.NEW(INS.DET.POLICY.NUMBER) EQ "" THEN
            R.NEW(INS.DET.SEN.POLICY.NUMBER) = Y.SEN.POLICY.NUMBER
            R.NEW(INS.DET.POLICY.NUMBER) = Y.SEN.POLICY.NUMBER : '-' : W.CEROS: Y.NEXT.SEN.POL.NUM
        END
    END

* esto es solo para actualizar el campo MONTO PRIMA TOTAL MENSUAL cuando ingresan por fabrica, ya que esta definido como campo NOINPUT
* y no pueden enviar el valor por OFS porque da un error

*   E = ""
*   Y.ARR.ID = System.getVariable("CURRENT.RCA")
*   IF E THEN
*      E = ""   19/06/2012 SJ.- comento este IF porque cuando es PVC no esta sumando el TOT.PRE.AMT desde FC
*      RETURN
*   END ELSE
    NO.OF.AMT = DCOUNT(R.NEW(INS.DET.MON.POL.AMT),@VM)
    FOR ITR.POL=1 TO NO.OF.AMT
        R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,ITR.POL> = R.NEW(INS.DET.MON.POL.AMT)<1,ITR.POL> + R.NEW(INS.DET.EXTRA.AMT)<1,ITR.POL>
    NEXT
*   END




RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.COMP.NAME, F.COMP.NAME)

RETURN

*
* ======================
INITIALISE:
* ======================
*

    FN.COMP.NAME = 'F.REDO.APAP.H.COMP.NAME'
    F.COMP.NAME = ''
    R.COMP.NAME = ''
    Y.COMP.NAME.ID = R.NEW(INS.DET.INS.COMPANY)
    Y.ERR.COMP.NAME = ''

    Y.POLICY.TYPE = R.NEW(INS.DET.INS.POLICY.TYPE)
    Y.CLASS.POLICY = R.NEW(INS.DET.CLASS.POLICY)

    W.CEROS = ''
    W.NUM.CEROS = 0

RETURN

END
