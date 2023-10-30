* @ValidationCode : Mjo4NTg3MTU3OTg6Q3AxMjUyOjE2OTg2Mzg0MjMwMDA6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 30 Oct 2023 09:30:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.LAPAP
SUBROUTINE REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*05-09-2023    VICTORIA S          R22 MANUAL CONVERSION   VM TO @VM,SM TO @SM
*30/10/2023	VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES      Interface Change by Santiago
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DFE.MAPPING
    $INSERT I_DFE.FRAME.WORK.COMMON
    $INSERT I_F.DFE.OUTWARD.WORK.FILE
    $INSERT I_DFE.OUTWARD.FILE.EXTRACT.COMMON
    
    GOSUB OPEN.FILES
 *R22 interface Unit testing changes- START   
    IF ID.RCON.L EQ 'REDO.COL.MAP.STATIC' THEN
        GOSUB PROCESS.STATIC
    END ELSE
*R22 interface Unit testing changes - END
        BEGIN CASE
            CASE MAP.FMT EQ 'O'
                GOSUB PROCESS.OUTWARD
            CASE MAP.FMT EQ 'I'
                GOSUB PROCESS.INWARD
        END CASE
    END
    
RETURN

OPEN.FILES:
    FN.DFE.MAPPING = "F.DFE.MAPPING"
    F.DFE.MAPPING  = ""
    CALL OPF(FN.DFE.MAPPING,F.DFE.MAPPING)
    CALL F.READ(FN.DFE.MAPPING,ID.RCON.L,R.DFE.MAPPING,F.DFE.MAPPING,DFE.ERR)
    C$R.MAPPING = R.DFE.MAPPING
RETURN

*R22 interface Unit testing changes- START
*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.STATIC:
*--------------
*** <region name=PROCESS.STATIC>
*** <desc> Process only for DFE.MAPPING=REDO.COL.MAP.STATIC </desc>
    Y.CONT = 1
    Y.TOT.VM = DCOUNT(R.DFE.MAPPING<DFE.MAP.APPL.FIELD.TEXT>,@VM)

    LOOP
    WHILE Y.CONT LE Y.TOT.VM
        Y.F1 = R.DFE.MAPPING<DFE.MAP.APPL.FIELD.TEXT,Y.CONT>
        Y.F2 = R.DFE.MAPPING<DFE.MAP.FIELD.CONV,Y.CONT>
        CHANGE @SM TO @VM IN Y.F2
        Y.F3<-1> = Y.F1:@VM:Y.F2
        Y.CONT++
    REPEAT
    R.RETURN.MSG = Y.F3
RETURN
*** </region name=PROCESS.STATIC>
*R22 interface Unit testing changes- END

*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.INWARD:
*--------------
*** <region name=PROCESS>
*** <desc> Main outward proccess </desc>
    INW.INDIV.RECORD = R.APP
    C$CURRENT.RECORD = INW.INDIV.RECORD
    DELIMITER = C$R.MAPPING<DFE.MAP.FIELD.DELIM>

    TRANSACTION.ID = ''
    CALL DFE.RETRIEVE.ID(TRANSACTION.ID)

    C$TXN.ID  = TRANSACTION.ID

    INIT.FLD.CNT = '1'
    TOTAL.FLD.CNT = DCOUNT(C$R.MAPPING<DFE.MAP.APPL.FIELD.NAME>,@VM) ;*R22 MANUAL CONVERSION

* Iterate till last field mapped in DFE.MAPPING.
    LOOP

    WHILE INIT.FLD.CNT LE TOTAL.FLD.CNT

* Get the field attibute for each field.

        CURR.APL.FLD.NAME = C$R.MAPPING<DFE.MAP.APPL.FIELD.NAME,INIT.FLD.CNT>   ;* Get configured application field name
        C$MAP.CURR.APPL.FLD.NAME = CURR.APL.FLD.NAME

* Update current field count for convertion logic.
        C$MAP.CURR.FIELD.NO = INIT.FLD.CNT

        CURR.APL.FLD.TYPE =  C$R.MAPPING<DFE.MAP.APPL.FIELD.TYPE,INIT.FLD.CNT>  ;* Get field type SINGLE / MULTI value/
        CURR.APL.FLD.DEF = C$R.MAPPING<DFE.MAP.APPL.FIELD.DEF,INIT.FLD.CNT>     ;* Get field attribute XX., XX< etc..
        CURR.FLD.POS = C$R.MAPPING<DFE.MAP.FIELD.POSITION,INIT.FLD.CNT>         ;* Get the configured position to fetch value in raw data.
        CURR.FLD.LEN = C$R.MAPPING<DFE.MAP.FIELD.LENGTH,INIT.FLD.CNT> ;* Get legnth of the each message for position based file.
        CURR.FLD.OPER = C$R.MAPPING<DFE.MAP.FIELD.OPERATION,INIT.FLD.CNT>       ;* Get field operation attached for each field.
        FIELD.CONV = C$R.MAPPING<DFE.MAP.FIELD.CONV,INIT.FLD.CNT>
        CURR.FLD.FMT = C$R.MAPPING<DFE.MAP.FIELD.FORMAT,INIT.FLD.CNT> ;* Get field format L#, L%, R%, R#
        CURR.APL.FLD.POS = C$R.MAPPING<DFE.MAP.APPL.FIELD.POSN,INIT.FLD.CNT>    ;* Get field SS position.
        APPL.MUL.FLD.POS = C$R.MAPPING<DFE.MAP.APPL.MUL.FLD.POS,INIT.FLD.CNT>
        APPL.SUB.FLD.POS = C$R.MAPPING<DFE.MAP.APPL.SUB.FLD.POS,INIT.FLD.CNT>
* Assign the record variable with the raw message
        GOSUB ASSIGN.FIELD.VALUES

        INIT.FLD.CNT++

    REPEAT
    
    R.RETURN.MSG = R.RECORD.ARRAY
    
RETURN
    
RETURN
*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
ASSIGN.FIELD.VALUES:
*-------------------
*** <region name= Assign Field Values>
*** <desc>Get the data's from the positions and assign it to each field.</desc>

* If the updation type is delimeter retreive the field value from the location
    
    IF C$R.MAPPING<DFE.MAP.RECORD.FORMAT> EQ 'DELIMITER' THEN
        CURR.FLD.VALUE = FIELD(INW.INDIV.RECORD,DELIMITER,CURR.FLD.POS)
    END

* If the updation type is position retreive the field value from the location and length.

    IF C$R.MAPPING<DFE.MAP.RECORD.FORMAT> EQ 'POSITION' THEN
        CURR.FLD.VALUE = INW.INDIV.RECORD[CURR.FLD.POS,CURR.FLD.LEN]
    END

* Check the field has configured with any field operations.

    IF CURR.FLD.OPER NE '' THEN
        CURR.APPL.FLD.VAL = CURR.FLD.VALUE
        CURR.FLD.VALUE = CURR.FLD.OPER

* The the field operation has ! operation to get common variables.

        IF INDEX(CURR.FLD.OPER,'!',1) THEN
            CALL DFE.RETRIEVE.COMMON.VALUES(CURR.FLD.VALUE)       ;* Retreive API for common varibles.
        END

* Check the field operation has routine. if yes execute the routine and pass the out args as values.
        IF CURR.FLD.OPER[1,1] EQ '@' THEN
            OPER.RTN.VAL = FIELD(CURR.FLD.OPER,'@',2)
            CURR.FLD.VALUE = CURR.APPL.FLD.VAL
            COMI = CURR.FLD.VALUE
            CALL @OPER.RTN.VAL
            CURR.FLD.VALUE = COMI
        END
    END

* Added by Santy
    IF FIELD.CONV NE '' THEN
        APPL.FIELD.VALUE = CURR.FLD.VALUE
        GOSUB PROCESS.FIELD.CONVERSION
        CURR.FLD.VALUE = APPL.FIELD.VALUE
    END

    IF CURR.FLD.VALUE NE '' THEN

* Coverting the the filed delims to T24 VM, SM in the raw data.
        CHANGE C$R.MAPPING<DFE.MAP.VM.DELIM> TO @VM IN CURR.FLD.VALUE ;*R22 MANUAL CONVERSION
        CHANGE C$R.MAPPING<DFE.MAP.SM.DELIM> TO @SM IN CURR.FLD.VALUE ;*R22 MANUAL CONVERSION

        IF INDEX(CURR.APL.FLD.POS,'.',1) THEN
* Process local reference fields
            GOSUB PROCESS.LOCAL.REF.FIELDS
        END ELSE
* Process template fields
            GOSUB PROCESS.TEMPLATE.FIELDS
        END

    END

RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.LOCAL.REF.FIELDS:
*------------------------
*** <region name= Process Local Reference Fields>
*** <desc>Assign record values to local reference fields</desc>
    
* Get the local ref field positios
    LOC.FLD.1 = FIELD(CURR.APL.FLD.POS,'.',1)
    LOC.FLD.2 = FIELD(CURR.APL.FLD.POS,'.',2)

* Update happens if value is not populated in previous command
    IF APPL.SUB.FLD.POS NE '' THEN
        R.RECORD.ARRAY<LOC.FLD.1,LOC.FLD.2,APPL.SUB.FLD.POS> = CURR.FLD.VALUE
    END ELSE
        R.RECORD.ARRAY<LOC.FLD.1,LOC.FLD.2> = CURR.FLD.VALUE
    END

RETURN

*** </region>


*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.TEMPLATE.FIELDS:
*-----------------------
*** <region name= Process Template Fields>
*** <desc>Assign record values to template fields.</desc>
    
* Update template standard fields.
    BEGIN CASE
        CASE INDEX(CURR.APL.FLD.NAME,':',1) GT 0    ;* If the field name is provided in FIELD.NAME:VM.POS:SM.POS (CUSTOMER:1:1)

            CU.MUL.POS = FIELD(CURR.APL.FLD.NAME,':',2)
            CU.SUB.POS = FIELD(CURR.APL.FLD.NAME,':',3)
            R.RECORD.ARRAY<CURR.APL.FLD.POS,CU.MUL.POS,CU.SUB.POS>  = CURR.FLD.VALUE

        CASE APPL.MUL.FLD.POS NE '' OR APPL.SUB.FLD.POS NE ''   ;* If either of multi and sub value positions are given, then proceed with this case

            IF APPL.MUL.FLD.POS NE '' AND APPL.SUB.FLD.POS NE '' THEN         ;* If both multi and sub value positions are given, then insert the value accordingly
                R.RECORD.ARRAY<CURR.APL.FLD.POS,APPL.MUL.FLD.POS,APPL.SUB.FLD.POS>  = CURR.FLD.VALUE
                RETURN
            END

            IF APPL.MUL.FLD.POS NE '' THEN      ;* If multi value alone given, then insert as per below condition
                R.RECORD.ARRAY<CURR.APL.FLD.POS,APPL.MUL.FLD.POS>  = CURR.FLD.VALUE
                RETURN
            END

            IF APPL.SUB.FLD.POS NE '' THEN      ;* If sub value alone given, then insert as per below condition
                R.RECORD.ARRAY<CURR.APL.FLD.POS,1,APPL.SUB.FLD.POS>  = CURR.FLD.VALUE
            END

        CASE 1      ;* If no multi/sub value positions provided in mapping
            R.RECORD.ARRAY<CURR.APL.FLD.POS> = CURR.FLD.VALUE
    END CASE


RETURN

*** </region>


*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.OUTWARD:
*---------------
*** <region name=PROCESS>
*** <desc> Main outward proccess </desc>
    
    Y.APP.NAME = FIELD(APP,"F.",2)
    FN.APPLICATION = APP
    F.APPLICATION  = ''
    CALL OPF(FN.APPLICATION,F.APPLICATION)
    CALL F.READ(FN.APPLICATION,ID.APP,R.APPLICATION,F.APPLICATION,APP.ERR)
    
    RECORD.FORMAT = C$R.MAPPING<DFE.MAP.RECORD.FORMAT>
    RECORD.ARRAY  = R.APP
    RECORD.ID     = ID.APP
    ID.POSITION  = C$R.MAPPING<DFE.MAP.ID.POSITION>
    ID.LENGTH   = C$R.MAPPING<DFE.MAP.ID.LENGTH>
    
    FIELD.COUNT = 1
    TOTAL.COUNT = DCOUNT(R.DFE.MAPPING<DFE.MAP.APPL.FIELD.NAME>,@VM) ;*R22 MANUAL CONVERSION
    
    CALL GET.STANDARD.SELECTION.DETS(FIELD(C$R.MAPPING<DFE.MAP.FILE.NAME>,'$',1),R.STANDARD.SELECTION)
    CALL FIELD.NAMES.TO.NUMBERS('LOCAL.REF',R.STANDARD.SELECTION,LOCAL.FIELD.NO,AF,AV,AS,DATA.TYPE,ERR.MSG)
    
    LOOP
    WHILE FIELD.COUNT LE TOTAL.COUNT
        APPL.FIELD.VALUE = ''
        APPL.FIELD.NAME  = C$R.MAPPING<DFE.MAP.APPL.FIELD.NAME,FIELD.COUNT>
        APPL.FIELD.POSN  = C$R.MAPPING<DFE.MAP.APPL.FIELD.POSN,FIELD.COUNT>
        FIELD.OPERATION  = C$R.MAPPING<DFE.MAP.FIELD.OPERATION,FIELD.COUNT>
        APPL.FIELD.TYPE  = C$R.MAPPING<DFE.MAP.APPL.FIELD.TYPE,FIELD.COUNT>
        APPL.MUL.FLD.POS = C$R.MAPPING<DFE.MAP.APPL.MUL.FLD.POS,FIELD.COUNT>
        APPL.SUB.FLD.POS = C$R.MAPPING<DFE.MAP.APPL.SUB.FLD.POS,FIELD.COUNT>
        FIELD.CONV       = C$R.MAPPING<DFE.MAP.FIELD.CONV,FIELD.COUNT>

        C$MAP.CURR.FIELD.NO = FIELD.COUNT         ;* Common variable for using in conversion routines

        IF RECORD.FORMAT EQ 'POSITION' OR RECORD.FORMAT EQ 'XML' THEN
            FIELD.POSITION  = FIELD.COUNT         ;* If record format is POSITION or XML, form the extract array with position as FIELD.COUNT
        END ELSE

* If record format is not POSITION or XML, form the extract array with position as per mapping record

            FIELD.POSITION  = C$R.MAPPING<DFE.MAP.FIELD.POSITION,FIELD.COUNT>
        END

        IF APPL.FIELD.NAME NE '' THEN
            GOSUB FIND.ACTUAL.FIELD.VALUE         ;* If APPL.FIELD.NAME is provided in mapping, then proceed to this gosub to retrieve value
        END ELSE
            GOSUB FIND.CONV.FIELD.VALUE
        END
        
        GOSUB FIELD.FORMATTING          ;* Format the field

        C$FIELD.VALUE.ARRAY<FIELD.COUNT>  = APPL.FIELD.VALUE
        EXTRACT.ARRAY<FIELD.POSITION>   = APPL.FIELD.VALUE
        FIELD.NORMALIZE<FIELD.POSITION>  = C$R.MAPPING<DFE.MAP.FIELD.NORMALIZE,FIELD.COUNT>
        APPL.FIELD.DEF<FIELD.POSITION>   = C$R.MAPPING<DFE.MAP.APPL.FIELD.DEF,FIELD.COUNT>
        
        IF RECORD.FORMAT EQ 'POSITION' THEN
            FIELD.VALUE  = EXTRACT.ARRAY<FIELD.COUNT>
            FIELD.POSITION  = C$R.MAPPING<DFE.MAP.FIELD.POSITION,FIELD.COUNT>
            FIELD.LENGTH  = C$R.MAPPING<DFE.MAP.FIELD.LENGTH,FIELD.COUNT>

            EXTRACT.LINE[FIELD.POSITION,FIELD.LENGTH] = FIELD.VALUE       ;* Assign the field value in corresponding position and length
        END
        
        FIELD.COUNT++
    REPEAT
    
    IF RECORD.FORMAT EQ 'DELIMITER' THEN
        IF ID.POSITION THEN       ;* If ID position is given in mapping, assign the record id accordingly
            EXTRACT.ARRAY<ID.POSITION> = RECORD.ID
        END

        EXTRACT.LINE = EXTRACT.ARRAY

* API returns the formatted extract line along with normalization if enabled

        CALL DFE.NORMALIZE.RECORD(EXTRACT.LINE,FIELD.NORMALIZE,APPL.FIELD.DEF)
    END
    R.RETURN.MSG = EXTRACT.LINE
    
RETURN
*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
FIND.ACTUAL.FIELD.VALUE:
*----------------------
*** <region name= Find Actual Field Value>
*** <desc>If APPL.FIELD.NAME field has value, then this gosub retrieves the value accordingly </desc>
    
    CHANGE "." TO "," IN APPL.FIELD.POSN
    LOCAL.REF.FLAG  = 0       ;* To identify as local ref field

    BEGIN CASE
        CASE INDEX(APPL.FIELD.POSN,',',1) GT 0        ;* Process to retrieve value from local ref fields with multi and sub value
            LOCAL.REF.FLAG  = 1
            FM.POSITION   = FIELD(APPL.FIELD.POSN,',',1)
            VM.POSITION   = FIELD(APPL.FIELD.POSN,',',2)
            APPL.FIELD.VALUE  = RECORD.ARRAY<FM.POSITION,VM.POSITION>
        CASE APPL.FIELD.POSN EQ 0 ;* Denotes @ID of the record
            APPL.FIELD.VALUE  = RECORD.ID
        CASE 1          ;* For single value fields
            APPL.FIELD.VALUE  = RECORD.ARRAY<APPL.FIELD.POSN>
    END CASE


    GOSUB RETRIEVE.LAST.VALUE.COUNT

    IF LOCAL.REF.FLAG EQ 1 AND APPL.FIELD.TYPE EQ 'M' THEN
        IF APPL.SUB.FLD.POS NE '' THEN  ;* For local ref fields with multi and sub values
            APPL.FIELD.VALUE = APPL.FIELD.VALUE<1,1,APPL.SUB.FLD.POS>
        END
    END ELSE
        IF APPL.FIELD.TYPE EQ 'M' THEN  ;* If field type is M then proceed
            GOSUB RETRIEVE.MULTI.SUB.VALUE        ;* To extract value from core fields with multi and sub value
        END
    END

    IF FIELD.OPERATION[1,1] EQ '@' AND FIELD.OPERATION NE '@ID' THEN  ;* If field operation has routine, call the routine
        FIELD.OPERATION.ROUTINE = FIELD(FIELD.OPERATION,'@',2)
        CALL @FIELD.OPERATION.ROUTINE(APPL.FIELD.VALUE)
    END

    IF FIELD.CONV NE '' THEN
        GOSUB PROCESS.FIELD.CONVERSION  ;* If field has conversion properties, proceed to this gosub
    END

RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
RETRIEVE.LAST.VALUE.COUNT:
*------------------------
*** <region name= Retrieve Last Value Count>
*** <desc>To retrieve values from multi and sub field positions if value is given as L in mapping</desc>

    IF APPL.MUL.FLD.POS EQ 'L' THEN
        APPL.MUL.FLD.POS = DCOUNT(APPL.FIELD.VALUE,@VM) ;*R22 MANUAL CONVERSION
    END

    IF APPL.SUB.FLD.POS EQ 'L' THEN
        APPL.SUB.FLD.POS = DCOUNT(APPL.FIELD.VALUE,@SM) ;*R22 MANUAL CONVERSION
    END

RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
RETRIEVE.MULTI.SUB.VALUE:
*-----------------------
*** <region name= Retrieve Multi Sub Value>
*** <desc>To retrieve values from multi and sub fields if corresponding positions are given in mapping</desc>

    IF APPL.MUL.FLD.POS NE '' AND APPL.SUB.FLD.POS NE '' THEN         ;* If both multi and sub value positions are given, then retrieve accordingly
        APPL.FIELD.VALUE = APPL.FIELD.VALUE<1,APPL.MUL.FLD.POS,APPL.SUB.FLD.POS>
        RETURN
    END

    IF APPL.MUL.FLD.POS NE '' THEN      ;* If multi value alone given, then retrieve as per below condition
        APPL.FIELD.VALUE = APPL.FIELD.VALUE<1,APPL.MUL.FLD.POS>
        RETURN
    END

    IF APPL.SUB.FLD.POS NE '' THEN      ;* If sub value alone given, then retrieve as per below condition
        APPL.FIELD.VALUE = APPL.FIELD.VALUE<1,1,APPL.SUB.FLD.POS>
    END

RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.FIELD.CONVERSION:
*-----------------------
*** <region name= Process Field Conversion>
*** <desc>If field conversion is provided, below logic retrieves the value accordingly</desc>
    
    FIELD.CONV.COUNT = DCOUNT(FIELD.CONV,@SM) ;*R22 MANUAL CONVERSION
    CONV.COUNT = 1

* Loop through the field conversions and retrieve the value
    
    LOOP
    WHILE CONV.COUNT LE FIELD.CONV.COUNT

        INDIVIDUAL.FIELD.CONV = FIELD(FIELD.CONV,@SM,CONV.COUNT)       ;* Individual conversion detail   --R22 MANUAL CONVERSION

        GOSUB PROCESS.INDIVIDUAL.FIELD.CONV

        CONV.COUNT = CONV.COUNT + 1
    REPEAT

RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
PROCESS.INDIVIDUAL.FIELD.CONV:
*----------------------------
*** <region name= Perform Extract Process>
*** <desc>To perform the extract process based on the mapping record</desc>
    
    FIELD.CONV.TYPE  = INDIVIDUAL.FIELD.CONV[1,2]
    FIELD.CONV.DETAILS  = INDIVIDUAL.FIELD.CONV[3,99]


    IF FIELD.CONV.TYPE EQ 'L ' THEN     ;* For retrieving values from linked applications

* If multi value and sub value fields has to be retrieved from linked applications from specific position
* it has to be in below format
* L APPLICATION.NAME,FIELD.NAME-VMposition.SMposition (L EB.LOOKUP,DESCRIPTION-1.1)
        APPL.MUL.FLD.POS  = FIELD(FIELD(FIELD.CONV.DETAILS,'-',2),'.',1)
        APPL.SUB.FLD.POS  = FIELD(FIELD(FIELD.CONV.DETAILS,'-',2),'.',2)

        FIELD.CONV.DETAILS = FIELD(FIELD.CONV.DETAILS,'-',1)
        CALL DFE.RETRIEVE.LINK.FIELD.VALUE(FIELD.CONV.DETAILS, APPL.FIELD.VALUE)          ;* Retrieves values from linked application

        GOSUB RETRIEVE.LAST.VALUE.COUNT

        GOSUB RETRIEVE.MULTI.SUB.VALUE

        RETURN
    END

    IF FIELD.CONV.TYPE EQ 'C ' THEN     ;* For retrieving values based on concat or arithmetic operations

        IF CONV.COUNT GT 1 THEN         ;*  If conversion is done multiple times for same field, append the value from previous iteration
            FIELD.CONV.DETAILS = APPL.FIELD.VALUE : FIELD.CONV.DETAILS
        END

* API performs the concat or arithmetic operations and returns the value accordingly

        CALL DFE.MERGE.FIELD.VALUES(C$FIELD.VALUE.ARRAY, FIELD.CONV.DETAILS, APPL.FIELD.VALUE)

        RETURN
    END

    IF FIELD.CONV.TYPE[1,1] EQ '@' THEN ;* If routine is attached in conversion, call the routine to get the response value
        FIELD.CONV.ROUTINE = FIELD(INDIVIDUAL.FIELD.CONV,'@',2)
        COMI = APPL.FIELD.VALUE
        CALL @FIELD.CONV.ROUTINE    ;*(APPL.FIELD.VALUE)
        APPL.FIELD.VALUE = COMI
        RETURN
    END


    IF APPL.FIELD.VALUE EQ '' THEN
        RETURN
    END

    IF INDIVIDUAL.FIELD.CONV[1,6] EQ 'FIELD ' THEN          ;* For performing FIELD operation based on delimiters.
        FIELD.CONV.DETAILS  = INDIVIDUAL.FIELD.CONV[7,99]
        CALL DFE.PERFORM.FIELD.OPERATION(C$FIELD.VALUE.ARRAY, FIELD.CONV.DETAILS, APPL.FIELD.VALUE)
        RETURN
    END

    IF INDIVIDUAL.FIELD.CONV[1,7] EQ 'CHANGE ' THEN         ;* For performing CHANGE operation based on conversion values
        FIELD.CONV.DETAILS  = INDIVIDUAL.FIELD.CONV[8,99]
        CALL DFE.PERFORM.CHANGE.OPERATION(C$FIELD.VALUE.ARRAY, FIELD.CONV.DETAILS, APPL.FIELD.VALUE)
        RETURN
    END

    IF INDIVIDUAL.FIELD.CONV[1,8] EQ 'EXTRACT ' THEN        ;* To extract value based on positions
        FIELD.CONV.DETAILS   = INDIVIDUAL.FIELD.CONV[9,99]
        CALL DFE.PERFORM.EXTRACT.OPERATION(FIELD.CONV.DETAILS, APPL.FIELD.VALUE)
    END

    IF INDIVIDUAL.FIELD.CONV[1,6] EQ 'STATIC' THEN        ;* To extract value based on positions
        APPL.FIELD.VALUE   = FIELD(INDIVIDUAL.FIELD.CONV,'STATIC ',2)	;*R22 interface Unit testing changes	;*Interface Change by Santiago
    END
    
RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
FIND.CONV.FIELD.VALUE:
*--------------------
*** <region name= Find Conv Field Value>
*** <desc>If APPL.FIELD.NAME field doesn't have value, then this gosub retrieves the value accordingly</desc>
    
    BEGIN CASE

        CASE INDEX(FIELD.OPERATION,'!',1) GT 0        ;* If common variable given in operation field

            APPL.FIELD.VALUE = FIELD.OPERATION
            CALL DFE.RETRIEVE.COMMON.VALUES(APPL.FIELD.VALUE)   ;* Api returns value for the common variable


        CASE FIELD.OPERATION[1,1] EQ '@' AND FIELD.OPERATION NE '@ID'     ;* If routine attached in the operation field
            FIELD.OPERATION.ROUTINE = FIELD(FIELD.OPERATION,'@',2)
            CALL @FIELD.OPERATION.ROUTINE(APPL.FIELD.VALUE)     ;* Calling routine to get the value

        CASE FIELD.OPERATION EQ '@ID'       ;* If @ID is given in operation, then record id will be assigned
            APPL.FIELD.VALUE = RECORD.ID

        CASE 1          ;* For other cases
            GOSUB RETRIEVE.OPERATION.VALUE  ;* Process if application field or constant value is given in operation

    END CASE

    IF FIELD.CONV NE '' THEN
        GOSUB PROCESS.FIELD.CONVERSION  ;* If field has conversion properties, proceed to this gosub
    END

RETURN

*** </region>

*** <region name= Field Formatting>
*** <desc>Process the field value to do the formatting before display</desc>
*------------------------------------------------------------------------------------------------------------------------------------
FIELD.FORMATTING:
*----------------

    IF C$R.MAPPING<DFE.MAP.FIELD.FORMAT,FIELD.COUNT>[1,1] EQ 'L' OR C$R.MAPPING<DFE.MAP.FIELD.FORMAT,FIELD.COUNT>[1,1] EQ 'R' THEN          ;* Format the field, if formatting is provided in mapping.
        APPL.FIELD.VALUE = FMTS(APPL.FIELD.VALUE,C$R.MAPPING<DFE.MAP.FIELD.FORMAT,FIELD.COUNT>:C$R.MAPPING<DFE.MAP.FIELD.LENGTH,FIELD.COUNT>)
    END

    IF C$R.MAPPING<DFE.MAP.FIELD.FORMAT,FIELD.COUNT>[1,1] EQ 'D' THEN
        USER.DATE.FORMAT = C$R.MAPPING<DFE.MAP.FIELD.FORMAT,FIELD.COUNT>[2,1]
        CALL EB.DATE.FORMAT.DISPLAY(APPL.FIELD.VALUE,APPL.FIELD.VALUE,'','')
    END

RETURN

*** </region>

*------------------------------------------------------------------------------------------------------------------------------------
RETRIEVE.OPERATION.VALUE:
*-----------------------
*** <region name= Retrieve Operation Value>
*** <desc>Retrieve value if application field or constant value is given in operation</desc>

* Retrieve the field number of the field provided in Operation field

    FIELD.NO = ''
    ERR.MSG = ''
    OPERATION.FIELD.NAME = FIELD.OPERATION
    CALL FIELD.NAMES.TO.NUMBERS(OPERATION.FIELD.NAME,R.STANDARD.SELECTION,FIELD.NO,AF,AV,AS,DATA.TYPE,ERR.MSG)

    IF ERR.MSG EQ '' AND FIELD.NO NE '' THEN      ;* If it's a core field, retrieve value from record array based on the field number
        APPL.FIELD.VALUE = RECORD.ARRAY<FIELD.NO>
        RETURN
    END

* Retrieve the local ref position of the field for the corresponding application

    LREF.POS = ''
    CALL MULTI.GET.LOC.REF(FIELD(C$R.MAPPING<DFE.MAP.FILE.NAME>,'$',1),FIELD.OPERATION,LREF.POS)

*  only values with quotes in OPERATION field will be considered as constants

    IF LREF.POS THEN          ;* If valid local ref field then get value based on local ref position
        APPL.FIELD.VALUE = RECORD.ARRAY<LOCAL.FIELD.NO,LREF.POS>
    END ELSE
        CHANGE '"' TO '' IN FIELD.OPERATION
        CHANGE "'" TO "" IN FIELD.OPERATION
        APPL.FIELD.VALUE = FIELD.OPERATION        ;* If the operation field is a constant value, then return the opearation value directly
    END

RETURN

*** </region>

END
