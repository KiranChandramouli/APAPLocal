* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.BCR.REPORT.GEN.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job TEMPLATE.EOD.
*-----------------------------------------------------------------------------
* 2011-08-28 : PACS00060197  - C.22 Integration
*              hpasquel@temenos.com
*-----------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT T24.BP I_F.ENQUIRY
*
    $INSERT TAM.BP I_F.REDO.BCR.REPORT.DATA
    $INSERT TAM.BP I_REDO.B.BCR.REPORT.GEN.COMMON
    $INSERT TAM.BP I_F.REDO.INTERFACE.PARAM
*

    GOSUB PROCESS
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    LIST.PARAMETERS = '' ; ID.LIST = ''

    IF K_PROCESS_FLAG EQ 0 THEN
        RETURN      ;* Process must not continue
    END

* Get The list to process from an Enquiry
*ENQ.SELECTION = "REDO.BCR.ARRANGEMENT.LIST"
*CALL CACHE.READ('F.ENQUIRY',ENQ.SELECTION,R.ENQ,Y.ER)
*IF Y.ER NE '' THEN
*TEXT = Y.ER
*CALL FATAL.ERROR("REDO.B.BCR.REPORT.GEN.SELECT")
*RETURN
*END

*OPERAND.LIST = 'EQ RG LT GT NE LK UL LE GE NR'
*OPERAND.LIST = CHANGE(OPERAND.LIST, ' ', FM)
*DATA.FILE.NAME = FIELD(R.ENQ<ENQ.FILE.NAME>,' ',1)
*CALL CONCAT.LIST.PROCESSOR
*AA.LIST = ENQ.KEYS        ;* ENQ.KEYS list of id's to process
*IF ENQ.ERROR NE '' THEN
*TEXT = ENQ.ERROR
*CALL FATAL.ERROR("REDO.B.BCR.REPORT.GEN.SELECT")
*RETURN
*END
    SEL.CMD = "SELECT ":FN.AA:" WITH ARR.STATUS EQ 'CURRENT' 'EXPIRED' 'MATURED' AND PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,AA.LIST,'',NO.REC,PGM.ERR)


    CALL OCOMO("Total of records to process " : NO.REC)
*
* PACS00060197     K.INT.CODE=''
* PACS00060197     K.INT.TYPE='BATCH'
*
*
    R.REDO.LOG<1>  = K.INT.CODE
    R.REDO.LOG<2>  = ''       ;* BAT.NO
    R.REDO.LOG<3>  = DCOUNT(AA.LIST,FM)
    R.REDO.LOG<4>  = ''       ;* INFO.OR
    R.REDO.LOG<5>  = ''       ;* INFO.DE
    R.REDO.LOG<6>  = ''       ;* ID.PROC
    R.REDO.LOG<7>  = '01'     ;* MON.TP
    R.REDO.LOG<8>  = 'SELECCION DE DATOS PARA SERVICIO REDO.BCR.REPORT'
    R.REDO.LOG<9>  = ''       ;* REC.CON
    R.REDO.LOG<10> = OPERATOR ;* EX.USER
    R.REDO.LOG<11> = TNO      ;* EX.PC
    R.REDO.LOG<12> = K.INT.TYPE

*
    CALL REDO.R.BCR.LOG(R.REDO.LOG)

    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,AA.LIST)
    CALL EB.CLEAR.FILE(FN.DATA,F.DATA)
    RETURN
*-----------------------------------------------------------------------------
END
