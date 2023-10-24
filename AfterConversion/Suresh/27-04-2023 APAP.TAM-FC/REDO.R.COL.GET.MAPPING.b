* @ValidationCode : MjoyMDg3MzUyNTU3OkNwMTI1MjoxNjgxODc1NjYyNDU4OmtpcmFuOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 09:11:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : kiran
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.R.COL.GET.MAPPING(P.IN.STATIC.MAPPING.ID, P.IN.R.STATIC.MAPPING, P.ERR.IF.NOFOUND, P.OUT.R.STATIC.MAPPING, P.IN.MAPPING.TYPE, P.MAP.VALUE)
******************************************************************************
*
*    Collector - Interface
*    Allows to get a value from the current static mapping
*    The mapping is def on RAD.CONDUIT.LINEAR on @id = REDO.COL.STATIC.MAPPING
*
* Input/Output
* -------------------
*                       P.IN.STATIC.MAPPING.ID     (in) identifier to find on RAD.CONDUIT.LINEAR
*                       P.IN.R.STATIC.MAPPING      (in) list of mapping to defined as fields on RAD.CONDUIT.LINEAR, in this example CURRENCY : FM : PRODUCT.GROUP etc
*                       P.ERR.IF.NOFOUND           (in) It indicates to launch error when the mappingValue not found. 1 : Yes, 0 ignore
*                       P.OUT.R.STATIC.MAPPING (in/out) If this sent, the routines doesn't call RAD.CONDUIT.LINEAR.TRANSLATOR and used its content
*                       P.IN.MAPPING.TYPE          (in) mapping type, according the fields defined on RAD.CONDUIT.LINEAR
*                                                       If blank is recieved, just do the initialization (get RAD.CONDUIT.LINEAR.TRANSLATOR result)
*                       P.MAP.VALUE            (in/out) Recieved the value to mapping, and the result mapping is returned
*                                                       If the mapping values was not def, then V$NULL is returned
*
*  E      (Common)      in case of Error
* =============================================================================
*
*    First Release : Paul Pasquel
*    Developed for : APAP - TAM
*    Developed by  : TAM
*    Date          : 2010-11-15 C.1 - Collector
*
*=======================================================================
* For Static MAPPING must be an entry on RAD.CONDUIT.LINEAR with @ID = REDO.COL.MAP.STATIC
* -----------------------------------------------------------------------------------------
*   2 TRANSLATION....... CUSTOM
*  18 IN.TYPE........... FLAT
*  20 IN.DELIM.......... <254>
*  21 OUT.TYPE.......... FLAT
*  23 OUT.DELIM......... <254>
*  ......................................
*  28. 1 FIELD.ID....... CURRENCY
*  29. 1 FIELD.TYPE..... REPORT
*  30. 1 IN.POSITION.... 1,1
*  31. 1 OUT.POSITION... 1,1
*  32. 1. 1 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 1. 1 CONV.PARAM.. DOP,1
*  32. 1. 2 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 1. 2 CONV.PARAM.. USD,2
*  ......................................
*  28. 2 FIELD.ID....... PRODUCT.GROUP
*  29. 2 FIELD.TYPE..... REPORT
*  30. 2 IN.POSITION.... 2,1
*  31. 2 OUT.POSITION... 2,1
*  32. 2. 1 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 2. 1 CONV.PARAM.. COMERCIAL,460
*  32. 2. 2 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 2. 2 CONV.PARAM.. CONSUMO,461
*  ......................................
*  28. 3 FIELD.ID....... PAYMENT.FREQ
*  29. 3 FIELD.TYPE..... REPORT
*  30. 3 IN.POSITION.... 3,1
*  31. 3 OUT.POSITION... 3,1
*  32. 3. 1 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 3. 1 CONV.PARAM.. e0Y e1M e0W e0D e0F,M
*  32. 3. 2 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 3. 2 CONV.PARAM.. e0Y e0M e2W e0D e0F,Q
*  ......................................
*  28. 4 FIELD.ID....... CAPITAL.STATUS
*  29. 4 FIELD.TYPE..... REPORT
*  30. 4 IN.POSITION.... 4,1
*  31. 4 OUT.POSITION... 4,1
*  32. 4. 1 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 4. 1 CONV.PARAM.. CUR,CUR
*  ......................................
*  28. 5 FIELD.ID....... INTEREST.STATUS
*  29. 5 FIELD.TYPE..... REPORT
*  30. 5 IN.POSITION.... 5,1
*  31. 5 OUT.POSITION... 5,1
*  32. 5. 1 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 5. 1 CONV.PARAM.. ACC,ACC
*  32. 5. 2 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 5. 2 CONV.PARAM.. AGE,AGE
*  32. 5. 3 CONV.FUNC... U-REDO.COL.CONCAT   valueToConcat
*  33. 5. 3 CONV.PARAM.. DUE,DUE
*  35. 5 PROCESS.NULL... YES
*
*------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*18-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,I TO I.VAR
*18-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.COL.CUSTOMER.COMMON
*
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*
    IF P.IN.MAPPING.TYPE EQ "" THEN
        CALL OCOMO("JUST CALLED FOR INITIALIZATION")
        RETURN
    END

    Y.MAP.VALUE = P.MAP.VALUE
    Y.MAP.TYPE = P.IN.MAPPING.TYPE
    R.MAP.TO.USE = ""
    Y.MAP.VALUE.FOUND = 0
    Y.TOTAL = DCOUNT(P.OUT.R.STATIC.MAPPING,@FM)
    FOR I.VAR = 1 TO Y.TOTAL
        Y.MAP.STATIC = P.OUT.R.STATIC.MAPPING<I.VAR,1>
        IF Y.MAP.STATIC  EQ Y.MAP.TYPE THEN
            R.MAP.TO.USE = P.OUT.R.STATIC.MAPPING<I.VAR>
            BREAK
        END
    NEXT I.VAR

    IF R.MAP.TO.USE EQ "" THEN
        CALL OCOMO("Record exist into RAD.CONDUIT.LINEAR but the entry " : Y.MAP.TYPE : "was removed")
        E = yStaticMappingNoDef : @FM : Y.MAP.TYPE : @VM : P.IN.STATIC.MAPPING.ID
        RETURN
    END

    Y.TOTAL = DCOUNT(R.MAP.TO.USE,@VM)
    Y.FOUND = 0
* The first position is FIELD.ID
    FOR I.VAR = 2 TO Y.TOTAL
        IF R.MAP.TO.USE<1,I.VAR>[",",1,1] EQ Y.MAP.VALUE THEN
            Y.MAP.VALUE = R.MAP.TO.USE<1,I.VAR>[",",2,1]
            Y.FOUND = 1
            BREAK
        END
    NEXT I.VAR

*    The caller must decide if this is or not an error
    IF NOT(Y.FOUND) THEN
        Y.MAP.VALUE = ''
        IF P.ERR.IF.NOFOUND THEN
            E = yNonMappingValue
            E<2> = P.MAP.VALUE : @VM : P.IN.MAPPING.TYPE
        END
    END

    P.MAP.VALUE = Y.MAP.VALUE

RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*

    IF P.IN.STATIC.MAPPING.ID EQ V$NULL AND P.OUT.R.STATIC.MAPPING EQ V$NULL THEN
        E = "ST-REDO.COL.PARAM.RTN.REQUIRED" : @VM : "PARAMETER & IS REQUIRED" : @FM : "P.IN.STATIC.MAPPING.ID"
        PROCESS.GOAHEAD = 0
        RETURN
    END
*
    IF P.IN.R.STATIC.MAPPING EQ V$NULL AND P.OUT.R.STATIC.MAPPING EQ V$NULL THEN

        E = "ST-REDO.COL.PARAM.RTN.REQUIRED" : @VM : "PARAMETER & IS REQUIRED &" : @FM : "P.IN.R.STATIC.MAPPING" : @VM : P.IN.MAPPING.TYPE
        PROCESS.GOAHEAD = 0
        RETURN
    END

    IF P.OUT.R.STATIC.MAPPING EQ "" THEN
        CALL RAD.CONDUIT.LINEAR.TRANSLATION("MAP", P.IN.STATIC.MAPPING.ID,  "", "", P.IN.R.STATIC.MAPPING, P.OUT.R.STATIC.MAPPING, Y.ERR)
        IF Y.ERR THEN

            E ="ERROR GETTING STATIC MAPPING FROM RAD " : Y.ERR
            PROCESS.GOAHEAD = 0
            RETURN
        END
    END

    IF P.OUT.R.STATIC.MAPPING EQ V$NULL THEN

        E = "ST-REDO.COL.STATIC.MAP.NO.DEF" : @VM : "STATIC MAPPING COLLECTOR NO DEF, RAD.CONDUIT.LINEAR @ID=REDO.COL.MAP.STATIC"
        PROCESS.GOAHEAD = 0
        RETURN
    END

*
    IF P.MAP.VALUE NE V$NULL AND P.IN.MAPPING.TYPE EQ V$NULL THEN

        E = "ST-REDO.COL.PARAM.RTN.REQUIRED" : @VM : "PARAMETER & IS REQUIRED, MAPPING &" : @FM : "P.IN.MAPPING.TYPE" : @VM : P.IN.MAPPING.TYPE
        PROCESS.GOAHEAD = 0
        RETURN
    END

*   IF P.MAP.VALUE EQ V$NULL AND P.IN.MAPPING.TYPE NE V$NULL THEN
*
*      E = "ST-REDO.COL.PARAM.RTN.REQUIRED" : VM : "PARAMETER & IS REQUIRED, MAPPING &" : FM : "P.MAP.VALUE" : VM : P.IN.MAPPING.TYPE
*      PROCESS.GOAHEAD = 0
*      RETURN
*   END

*
RETURN
*
END
